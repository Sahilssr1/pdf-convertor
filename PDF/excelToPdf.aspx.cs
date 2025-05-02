using System;
using System.IO;
using Aspose.Cells;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PDFconvertor.PDF
{
    public partial class excelToPdf : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnConvert_Click(object sender, EventArgs e)
        {
            // Check if a file is uploaded
            if (!fileUpload.HasFile)
            {
                lblMessage.Text = "❌ Please upload an Excel file.";
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
                string excelPath = Path.Combine(uploadPath, fileUpload.FileName);
                fileUpload.SaveAs(excelPath);

                // Convert Excel to PDF
                string pdfPath = ConvertExcelToPdf(excelPath);

                lblMessage.Text = $"✅ Conversion successful! <br><a href='{pdfPath}' target='_blank'>📄 Download PDF File</a>";
                lblMessage.CssClass = "success";
            }
            catch (Exception ex)
            {
                lblMessage.Text = "❌ Error: " + ex.Message;
                lblMessage.CssClass = "error";
            }
        }

        private string ConvertExcelToPdf(string excelPath)
        {
            string pdfFileName = Path.GetFileNameWithoutExtension(excelPath) + ".pdf";
            string pdfFilePath = Path.Combine(Server.MapPath("~/Uploads/"), pdfFileName);

            try
            {
                if (!File.Exists(excelPath))
                {
                    throw new FileNotFoundException("Excel file not found.", excelPath);
                }

                string fileExtension = Path.GetExtension(excelPath).ToLower();
                if (fileExtension != ".xls" && fileExtension != ".xlsx")
                {
                    throw new Exception("Invalid file format. Only .xls and .xlsx are supported.");
                }

                // Load Excel file with auto-detect format
                LoadOptions loadOptions = new LoadOptions(LoadFormat.Auto);
                Workbook workbook = new Workbook(excelPath, loadOptions);

                // Debugging: Log detected format
                Console.WriteLine("Detected Excel Format: " + workbook.FileFormat);

                // Save as PDF
                workbook.Save(pdfFilePath, SaveFormat.Pdf);

                return "/Uploads/" + pdfFileName;
            }
            catch (Exception ex)
            {
                throw new Exception("Error converting Excel to PDF: " + ex.Message);
            }
        }

    }
}
