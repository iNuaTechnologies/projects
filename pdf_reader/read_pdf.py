import os
import pypdf

folder = r"C:\Users\Adi Livnat\Desktop\inua\projects-private\Valary"
output_path = r"C:\Users\Adi Livnat\Desktop\inua\projects\pdf_reader\valary_output.txt"

files = [f for f in os.listdir(folder) if f.endswith(".pdf")]
if not files:
    print("No PDF files found in Valary folder.")
    exit(1)

pdf_path = os.path.join(folder, files[0])
print(f"Reading PDF: {pdf_path}")

reader = pypdf.PdfReader(pdf_path)
text_content = []

for idx, page in enumerate(reader.pages):
    text = page.extract_text()
    text_content.append(f"----------------Page ({idx}) Break----------------")
    text_content.append(text)

full_text = "\n".join(text_content)

with open(output_path, "w", encoding="utf-8") as f:
    f.write(full_text)

print(f"PDF parsed successfully, output written to: {output_path}")
