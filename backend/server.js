const express = require("express");
const cors = require("cors");
const nodemailer = require("nodemailer");

const app = express();
app.use(cors());
app.use(express.json());

const codes = new Map();

// Configure email sender
const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: "kfattahi00@gmail.com",
    pass: "kfne sqgu uupc vgzp"
  }
});

// SEND EMAIL CODE
app.post("/send-email-code", async (req, res) => {
  const { email } = req.body;

  const code = Math.floor(100000 + Math.random() * 900000).toString();
  codes.set(email, code);

  try {
    await transporter.sendMail({
      from: "kfattahi00@gmail.com",
      to: email,
      subject: "Your Verification Code",
      text: `Your verification code is: ${code}`
    });

    res.json({ success: true });
  } catch (err) {
    res.json({ success: false, error: err.message });
  }
});

// VERIFY EMAIL CODE
app.post("/verify-email-code", (req, res) => {
  const { email, code } = req.body;

  if (codes.get(email) === code) {
    codes.delete(email);
    return res.json({ success: true });
  }

  res.json({ success: false });
});

app.listen(3000, "0.0.0.0", () => console.log("Email API running on 3000"));