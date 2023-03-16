import os
import re
import boto3
from PyPDF4 import PdfFileReader, PdfFileWriter

search_string1 = "search_string1"
search_string2 = "search_string1"

bucket_name = "bucketName"
prefix = "some/path/"

s3 = boto3.client("s3")
response = s3.list_objects_v2(Bucket=bucket_name, Prefix=prefix)
for obj in response['Contents']:
    if obj['Key'].endswith('.pdf'):
        s3.download_file(bucket_name, obj['Key'], os.path.basename(obj['Key']))
        print(os.path.basename(obj['Key']))


for filename in os.listdir(os.getcwd()):
    if filename.endswith(".pdf"):
        with open(filename, 'rb') as pdf_file:
            num_pages = PdfFileReader(pdf_file).getNumPages()
            found_pages = []
            for page_num in range(num_pages):
                page = PdfFileReader(pdf_file).getPage(page_num)
                page_text = page.extractText()
                if re.search(search_string1 + '|' + search_string2, page_text):
                    found_pages.append(page_num)
            if found_pages:
                pdf_writer = PdfFileWriter()
                for page_num in found_pages:
                    page = PdfFileReader(pdf_file).getPage(page_num)
                    pdf_writer.addPage(page)
                    output_filename = f"{filename[:-4]}_page{page_num+1}.pdf"
                    with open(output_filename, "wb") as output_file:
                        pdf_writer.write(output_file)
                    s3.upload_file(output_filename, bucket_name, output_filename)
                    os.remove(output_filename)
            else:
                print(f"No instances of '{search_string1}' or '{search_string2}' found in {filename}")