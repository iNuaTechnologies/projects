const fs = require('fs');
const pdf = require('pdf-parse');

const pdfPath = 'C:\\Users\\Adi Livnat\\Desktop\\inua\\projects-private\\Valary\\Valary, solar panels __ Michal, iNua - 2026_06_23 14_54 IDT - Notes by Gemini.pdf';
const outputPath = 'C:\\Users\\Adi Livnat\\Desktop\\inua\\projects\\pdf_reader\\valary_output.txt';

let dataBuffer = fs.readFileSync(pdfPath);

pdf(dataBuffer).then(function(data) {
    fs.writeFileSync(outputPath, data.text);
    console.log("PDF parsed successfully, output written to:", outputPath);
}).catch(err => {
    console.error("Error parsing PDF:", err);
});
