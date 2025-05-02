using System;
using System.IO;
using Aspose.Pdf;
using System.Web.UI;


namespace PDFconvertor.PDF
{
    public partial class pdfToExcel : System.Web.UI.Page
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
                // Define Uploads directory
                string uploadPath = Server.MapPath("~/Uploads/");
                if (!Directory.Exists(uploadPath))
                {
                    Directory.CreateDirectory(uploadPath);
                }

                // Save uploaded PDF
                string pdfPath = Path.Combine(uploadPath, fileUpload.FileName);
                fileUpload.SaveAs(pdfPath);

                // Convert PDF to Excel
                string excelPath = ConvertPdfToExcel(pdfPath);

                lblMessage.Text = $"✅ Conversion successful! <br><a href='{excelPath}' target='_blank'>📊 Download Excel File</a>";
                lblMessage.CssClass = "success";
            }
            catch (Exception ex)
            {
                lblMessage.Text = "❌ Error: " + ex.Message;
                lblMessage.CssClass = "error";
            }
        }
        private string ConvertPdfToExcel(string pdfPath)
        {
            string excelFileName = Path.GetFileNameWithoutExtension(pdfPath) + ".xlsx";
            string excelFilePath = Path.Combine(Server.MapPath("~/Uploads/"), excelFileName);

            try
            {
                // Load PDF document
                using (Document pdfDocument = new Document(pdfPath))
                {
                    // Check if the PDF has extractable content
                    if (pdfDocument.Pages.Count == 0)
                    {
                        throw new Exception("PDF has no pages to convert.");
                    }

                    // Save as XLSX
                     pdfDocument.Save(excelFilePath, SaveFormat.Excel);
                }

                // Verify the file was created
                if (!File.Exists(excelFilePath))
                {
                    throw new Exception("Excel file was not created.");
                }

                return "/Uploads/" + excelFileName;
            }
            catch (Exception ex)
            {
                // Include full exception details
                throw new Exception("Error during PDF to Excel conversion: " + ex.ToString());
            }
        }



    }
}
