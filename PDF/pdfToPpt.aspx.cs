using System;
using System.IO;
using Aspose.Pdf;
using System.Web.UI;

namespace PDFconvertor.PDF
{
    public partial class pdfToPpt : System.Web.UI.Page
    {
        protected void btnConvert_Click(object sender, EventArgs e)
        {
            if (!fileUpload.HasFile)
            {
                lblMessage.Text = "❌ Please upload a PDF file.";
                lblMessage.CssClass = "error";
                return;
            }

            try
            {
                // Define upload directory
                string uploadPath = Server.MapPath("~/Uploads/");
                if (!Directory.Exists(uploadPath))
                {
                    Directory.CreateDirectory(uploadPath);
                }

                // Save uploaded PDF
                string pdfPath = Path.Combine(uploadPath, fileUpload.FileName);
                fileUpload.SaveAs(pdfPath);

                // Convert PDF to PowerPoint
                string pptPath = ConvertPdfToPpt(pdfPath);

                lblMessage.Text = $"✅ Conversion successful! <br><a href='{pptPath}' target='_blank'>📊 Download PPTX File</a>";
                lblMessage.CssClass = "success";
            }
            catch (Exception ex)
            {
                lblMessage.Text = "❌ Error: " + ex.Message;
                lblMessage.CssClass = "error";
            }
        }

        private string ConvertPdfToPpt(string pdfPath)
        {
            string pptFileName = Path.GetFileNameWithoutExtension(pdfPath) + ".pptx";
            string pptFilePath = Path.Combine(Server.MapPath("~/Uploads/"), pptFileName);

            // Load PDF document
            Document pdfDocument = new Document(pdfPath);

            // Save as PowerPoint (PPTX format)
            pdfDocument.Save(pptFilePath, SaveFormat.Pptx);

            return "/Uploads/" + pptFileName; // Return relative path
        }
    }
}
