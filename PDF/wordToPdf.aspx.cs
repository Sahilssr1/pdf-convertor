using System;
using System.IO;
using Aspose.Words;
using System.Web;
using System.Web.UI;

namespace PDFconvertor.PDF
{
    public partial class wordToPdf : System.Web.UI.Page
    {
        protected void btnConvert_Click(object sender, EventArgs e)
        {
            // Check if a file is uploaded
            if (!fileUpload.HasFile)
            {
                lblMessage.Text = "❌ Please upload a Word file.";
                lblMessage.CssClass = "error";
                return;
            }

            try
            {
                // Define Uploads directory
                string uploadPath = Server.MapPath("~/Uploads/");
                if (!Directory.Exists(uploadPath))
                {
                    Directory.CreateDirectory(uploadPath);
                }

                // Save uploaded file
                string wordPath = Path.Combine(uploadPath, fileUpload.FileName);
                fileUpload.SaveAs(wordPath);

                // Convert Word to PDF
                string pdfPath = ConvertWordToPdf(wordPath);

                lblMessage.Text = $"✅ Conversion successful! <br><a href='{pdfPath}' target='_blank'>📄 Download PDF File</a>";
                lblMessage.CssClass = "success";
            }
            catch (Exception ex)
            {
                lblMessage.Text = "❌ Error: " + ex.Message;
                lblMessage.CssClass = "error";
            }
        }

        private string ConvertWordToPdf(string wordPath)
        {
            string pdfFileName = Path.GetFileNameWithoutExtension(wordPath) + ".pdf";
            string pdfFilePath = Path.Combine(Server.MapPath("~/Uploads/"), pdfFileName);

            // Load the Word document
            Document doc = new Document(wordPath);

            // Save as PDF
            doc.Save(pdfFilePath, SaveFormat.Pdf);

            return "/Uploads/" + pdfFileName; // Return relative path
        }
    }
}
