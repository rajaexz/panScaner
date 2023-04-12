const express = require('express');
const multer = require('multer');
const Tesseract = require('tesseract.js');

const app = express();
const upload = multer({ dest: 'uploads/' });

app.get('/', (req, res) => {
  res.send('Hello, world!');
});

app.post('/scan', upload.single('image'), (req, res) => {
  Tesseract.recognize(req.file.path)
    .progress((progress) => {
      console.log(`Progress: ${progress}`);
    })
    .then((result) => {
      res.json(result.text);
    })
    .catch((error) => {
      console.error(error);
      res.sendStatus(500);
    });
});

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`Server started on port ${PORT}`);
});
