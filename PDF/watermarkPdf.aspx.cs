using System;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using System.Web;
using System.Web.UI;
using iTextSharp.text;
using iTextSharp.text.pdf;

namespace PDFconvertor.PDF
{
    public partial class watermarkPdf : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnUpload_Click(object sender, EventArgs e)
        {
            if (fileUpload.HasFile)
            {
                try
                {
                    string filePath = Server.MapPath("~/Uploads/") + fileUpload.FileName;
                    fileUpload.SaveAs(filePath);

                    string outputFilePath = Server.MapPath("~/Uploads/Watermarked_" + fileUpload.FileName);

                    string watermarkText = txtWatermark.Text; // Get watermark text from input field
                    AddWatermark(filePath, outputFilePath, watermarkText);

                    lblMessage.Text = "Watermark added successfully! <a href='" + ResolveUrl("~/Uploads/Watermarked_" + fileUpload.FileName) + "' target='_blank'>Download Here</a>";
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

        private void AddWatermark(string inputPdf, string outputPdf, string watermarkText)
        {
            using (Stream inputStream = new FileStream(inputPdf, FileMode.Open, FileAccess.Read, FileShare.Read))
            using (Stream outputStream = new FileStream(outputPdf, FileMode.Create, FileAccess.Write, FileShare.None))
            {
                PdfReader reader = new PdfReader(inputStream);
                PdfStamper stamper = new PdfStamper(reader, outputStream);
                int pageCount = reader.NumberOfPages;

                PdfContentByte canvas;
                BaseFont bf = BaseFont.CreateFont(BaseFont.HELVETICA, BaseFont.CP1252, BaseFont.NOT_EMBEDDED);

                for (int i = 1; i <= pageCount; i++)
                {
                    canvas = stamper.GetOverContent(i);
                    canvas.BeginText();
                    canvas.SetFontAndSize(bf, 40);
                    canvas.SetColorFill(BaseColor.GRAY);
                    canvas.ShowTextAligned(Element.ALIGN_CENTER, watermarkText, 300, 400, 45);
                    canvas.EndText();
                }

                stamper.Close();
                reader.Close();
            }
        }
    }
}
