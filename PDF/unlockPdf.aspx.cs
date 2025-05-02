using System;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;
using iTextSharp.text.pdf;

namespace PDFconvertor.PDF
{
    public partial class unlockPdf : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnUnlock_Click(object sender, EventArgs e)
        {
            if (fileUpload.HasFile)
            {
                try
                {
                    // Save uploaded file
                    string fileName = Path.GetFileName(fileUpload.FileName);
                    string uploadDir = Server.MapPath("~/Uploads/");
                    string filePath = Path.Combine(uploadDir, fileName);

                    if (!Directory.Exists(uploadDir))
                    {
                        Directory.CreateDirectory(uploadDir);
                    }

                    fileUpload.SaveAs(filePath);

                    string outputFilePath = Path.Combine(uploadDir, "Unlocked_" + fileName);
                    string password = txtPassword.Text; // User-entered password

                    if (UnlockPDF(filePath, outputFilePath, password))
                    {
                        lblMessage.ForeColor = System.Drawing.Color.Green;
                        lblMessage.Text = "PDF unlocked successfully! <a href='" + ResolveUrl("~/Uploads/Unlocked_" + fileName) + "' target='_blank'>Download Here</a>";
                    }
                    else
                    {
                        lblMessage.Text = "Invalid password or unable to unlock the PDF.";
                    }
                }
                catch (Exception ex)
                {
                    lblMessage.Text = "Error: " + ex.Message;
                }
            }
            else
            {
                lblMessage.Text = "Please upload a PDF file.";
            }
        }

        private bool UnlockPDF(string inputPdf, string outputPdf, string password)
        {
            try
            {
                // Open the PDF with the provided password
                PdfReader reader = new PdfReader(inputPdf, new System.Text.UTF8Encoding().GetBytes(password));

                // Create a new PDF without encryption
                using (FileStream outputStream = new FileStream(outputPdf, FileMode.Create, FileAccess.Write, FileShare.None))
                {
                    PdfStamper stamper = new PdfStamper(reader, outputStream);
                    stamper.Writer.SetEncryption(null, null, PdfWriter.ALLOW_PRINTING | PdfWriter.ALLOW_COPY, PdfWriter.STRENGTH128BITS);
                    stamper.Close();
                }

                reader.Close();
                return true;
            }
            catch
            {
                return false; // PDF could not be unlocked (wrong password or other issue)
            }
        }
    }
}
