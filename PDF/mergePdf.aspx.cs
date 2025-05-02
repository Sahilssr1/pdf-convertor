using System;
using System.IO;
using iTextSharp.text;
using iTextSharp.text.pdf;

namespace PDFconvertor.PDF
{
    public partial class mergePdf : System.Web.UI.Page
    {
        protected void btnMerge_Click(object sender, EventArgs e)
        {
            // Ensure at least two files are uploaded
            if (!fileUpload1.HasFile || !fileUpload2.HasFile)
            {
                lblMessage.Text = "Please upload at least two PDF files.";
                lblMessage.CssClass = "message error";
                return;
            }

            // Create the Uploads directory if it doesn't exist
            string uploadPath = Server.MapPath("~/Uploads/");
            if (!Directory.Exists(uploadPath))
            {
                Directory.CreateDirectory(uploadPath);
            }

            // Collect uploaded files
            var fileUploads = new[] { fileUpload1, fileUpload2, fileUpload3, fileUpload4 };
            var validFiles = new System.Collections.Generic.List<string>();
            var filePaths = new System.Collections.Generic.List<string>();

            for (int i = 0; i < fileUploads.Length; i++)
            {
                if (fileUploads[i].HasFile)
                {
                    string filePath = Path.Combine(uploadPath, fileUploads[i].FileName);
                    fileUploads[i].SaveAs(filePath);
                    validFiles.Add(fileUploads[i].FileName);
                    filePaths.Add(filePath);
                }
            }

            // Validate at least two files
            if (validFiles.Count < 2)
            {
                lblMessage.Text = "Please upload at least two PDF files.";
                lblMessage.CssClass = "message error";
                return;
            }

            // Set merged file path
            string mergedPath = Path.Combine(uploadPath, "Merged.pdf");

            // Merge PDFs
            MergePDFs(filePaths, mergedPath);

            // Provide download link
            Response.ContentType = "application/pdf";
            Response.AppendHeader("Content-Disposition", "attachment; filename=Merged.pdf");
            Response.TransmitFile(mergedPath);
            Response.End();

            // Success message (may not display due to Response.End)
            lblMessage.Text = "PDFs merged successfully.";
            lblMessage.CssClass = "message success";
        }

        private void MergePDFs(System.Collections.Generic.List<string> filePaths, string outputFile)
        {
            using (FileStream stream = new FileStream(outputFile, FileMode.Create))
            {
                Document document = new Document();
                PdfCopy pdfCopy = new PdfCopy(document, stream);
                document.Open();

                // Merge all PDFs
                foreach (string file in filePaths)
                {
                    AddPdfToCopy(pdfCopy, file);
                }

                document.Close();
            }
        }

        private void AddPdfToCopy(PdfCopy pdfCopy, string pdfPath)
        {
            PdfReader reader = new PdfReader(pdfPath);
            for (int i = 1; i <= reader.NumberOfPages; i++)
            {
                pdfCopy.AddPage(pdfCopy.GetImportedPage(reader, i));
            }
            reader.Close();
        }
    }
}