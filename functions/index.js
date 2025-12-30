const admin = require("firebase-admin");
admin.initializeApp();

const { onDocumentCreated, onDocumentUpdated } = require("firebase-functions/v2/firestore");

// =======================================================
// 1) JOB CREATED -> Notify freelancers + save inbox
// =======================================================
exports.onJobCreatedNotifyFreelancers = onDocumentCreated(
  "jobs/{jobId}",
  async (event) => {
    const snap = event.data;
    if (!snap) return;

    const jobId = event.params.jobId;
    const job = snap.data() || {};

    const title = (job.title || "New Job").toString();

    let body = "A client posted a new job. Tap to view.";
    if (job.description) body = String(job.description).slice(0, 120);

    // 🔔 Push to topic
    await admin.messaging().send({
      topic: "freelancers",
      notification: { title, body },
      data: {
        type: "job_created",
        refId: jobId,
      },
    });

    // 📥 Save inbox for all freelancers
    const usersSnap = await admin
      .firestore()
      .collection("users")
      .where("role", "==", "freelancer")
      .get();

    const batch = admin.firestore().batch();

    usersSnap.docs.forEach((uDoc) => {
      const notifRef = admin
        .firestore()
        .collection("users")
        .doc(uDoc.id)
        .collection("notifications")
        .doc();

      batch.set(notifRef, {
        type: "job_created",
        title,
        body,
        refId: jobId,
        read: false,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      });
    });

    await batch.commit();
  }
);

// =======================================================
// 2) PROPOSAL STATUS CHANGED -> Notify freelancer + save inbox
// =======================================================
exports.onProposalStatusChangedNotifyFreelancer = onDocumentUpdated(
  "proposals/{proposalId}",
  async (event) => {
    const data = event.data;
    if (!data || !data.before || !data.after) return;

    const before = data.before.data();
    const after = data.after.data();
    if (!before || !after) return;

    const beforeStatus = (before.status || "pending").toString();
    const afterStatus = (after.status || "pending").toString();

    // فقط إذا تغير من pending ل accepted/rejected
    if (beforeStatus === afterStatus) return;
    if (beforeStatus !== "pending") return;
    if (afterStatus !== "accepted" && afterStatus !== "rejected") return;

    const proposalId = event.params.proposalId;

    const freelancerId = (after.freelancerId || "").toString();
    const jobId = (after.jobId || "").toString();
    const jobTitle = (after.jobTitle || "Job").toString();
    if (!freelancerId) return;

    const title =
      afterStatus === "accepted" ? "Proposal accepted 🎉" : "Proposal rejected";

    const body =
      afterStatus === "accepted"
        ? `Your proposal for "${jobTitle}" was accepted.`
        : `Your proposal for "${jobTitle}" was rejected.`;

    // 1) Send push to freelancer tokens
    const userDoc = await admin
      .firestore()
      .collection("users")
      .doc(freelancerId)
      .get();

    const user = userDoc.data() || {};
    const tokens = Array.isArray(user.fcmTokens) ? user.fcmTokens : [];

    if (tokens.length > 0) {
      const res = await admin.messaging().sendEachForMulticast({
        tokens,
        notification: { title, body },
        data: {
          type: "proposal_status",
          proposalId,
          jobId,
          status: afterStatus,
        },
      });

      // تنظيف tokens الخربانة
      const invalid = [];
      res.responses.forEach((r, idx) => {
        if (!r.success) {
          const code = r && r.error && r.error.code ? r.error.code : "";
          if (/registration-token-not-registered|invalid-argument/.test(code)) {
            invalid.push(tokens[idx]);
          }
        }
      });

      for (let i = 0; i < invalid.length; i++) {
        await admin.firestore().collection("users").doc(freelancerId).update({
          fcmTokens: admin.firestore.FieldValue.arrayRemove(invalid[i]),
        });
      }
    }

    // 2) Save inbox notification
    await admin
      .firestore()
      .collection("users")
      .doc(freelancerId)
      .collection("notifications")
      .add({
        type: "proposal_status",
        title,
        body,
        refId: proposalId,
        jobId,
        status: afterStatus,
        read: false,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      });
  }
);

// =======================================================
// 3) CHAT MESSAGE CREATED -> Notify receiver ONLY (NO inbox)
//    - exclude sender tokens to avoid self notification
//    - support 2 participants (or more) safely
// =======================================================
exports.onChatMessageCreatedNotify = onDocumentCreated(
  "chats/{chatId}/messages/{messageId}",
  async (event) => {
    const snap = event.data;
    if (!snap) return;

    const chatId = event.params.chatId;
    const msg = snap.data() || {};

    const senderId = (msg.senderId || "").toString();
    const textRaw = (msg.text || "").toString();
    const text = textRaw.trim();
    if (!senderId || !text) return;

    // 1) read chat participants
    const chatDoc = await admin.firestore().collection("chats").doc(chatId).get();
    const chat = chatDoc.data() || {};

    // عندك اسمها participants في الكود
    const participants = Array.isArray(chat.participants)
      ? chat.participants.map((p) => String(p))
      : [];

    if (participants.length === 0) return;

    // 2) receivers = كل المشاركين ما عدا المرسل
    const receiverIds = participants.filter((p) => p && p !== senderId);
    if (receiverIds.length === 0) return;

    // 3) sender tokens (لازم نستبعدهم حتى لو مخزنة بالغلط عند غيره)
    const senderDoc = await admin.firestore().collection("users").doc(senderId).get();
    const senderData = senderDoc.data() || {};
    const senderTokens = Array.isArray(senderData.fcmTokens) ? senderData.fcmTokens : [];

    // 4) get receivers tokens
    const receiverDocs = await Promise.all(
      receiverIds.map((uid) => admin.firestore().collection("users").doc(uid).get())
    );

    // collect all receiver tokens
    const receiverTokens = [];
    receiverDocs.forEach((d) => {
      const u = d.data() || {};
      const t = Array.isArray(u.fcmTokens) ? u.fcmTokens : [];
      for (let i = 0; i < t.length; i++) receiverTokens.push(t[i]);
    });

    // ✅ remove duplicates
    const uniqueTokens = Array.from(new Set(receiverTokens));

    // ✅ exclude sender tokens
    const tokens = uniqueTokens.filter((t) => senderTokens.indexOf(t) === -1);

    if (tokens.length === 0) return;

    // (اختياري) عنوان فيه اسم المرسل
    const senderName = (senderData.name || "New message").toString();
    const body = text.length > 120 ? text.slice(0, 120) : text;

    const res = await admin.messaging().sendEachForMulticast({
      tokens,
      notification: { title: senderName, body },
      data: {
        type: "chat_message",
        chatId,
      },
    });

    // تنظيف tokens الخربانة من حسابات المستلمين
    const invalid = [];
    res.responses.forEach((r, idx) => {
      if (!r.success) {
        const code = r && r.error && r.error.code ? r.error.code : "";
        if (/registration-token-not-registered|invalid-argument/.test(code)) {
          invalid.push(tokens[idx]);
        }
      }
    });

    // حذف invalid token من كل receiver (لأنه ممكن نفس token يكون عند أكثر من واحد)
    for (let i = 0; i < invalid.length; i++) {
      const bad = invalid[i];
      for (let j = 0; j < receiverIds.length; j++) {
        await admin.firestore().collection("users").doc(receiverIds[j]).update({
          fcmTokens: admin.firestore.FieldValue.arrayRemove(bad),
        });
      }
    }

    // ❌ NO inbox save for chat messages (حسب طلبك)
  }
);
