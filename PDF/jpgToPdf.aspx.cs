using System;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;
using iTextSharp.text;
using iTextSharp.text.pdf;
using System.Drawing;
using System.Web;

namespace PDFconvertor.PDF
{
    public partial class jpgToPdf : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnConvert_Click(object sender, EventArgs e)
        {
            if (fileUpload.HasFiles)
            {
                try
                {
                    string uploadDir = Server.MapPath("~/Uploads/");
                    if (!Directory.Exists(uploadDir))
                    {
                        Directory.CreateDirectory(uploadDir);
                    }

                    string outputPdfPath = Path.Combine(uploadDir, "Converted_" + DateTime.Now.Ticks + ".pdf");

                    using (FileStream stream = new FileStream(outputPdfPath, FileMode.Create, FileAccess.Write, FileShare.None))
                    {
                        Document document = new Document();
                        PdfWriter.GetInstance(document, stream);
                        document.Open();

                        foreach (HttpPostedFile uploadedFile in fileUpload.PostedFiles)
                        {
                            string imagePath = Path.Combine(uploadDir, Path.GetFileName(uploadedFile.FileName));
                            uploadedFile.SaveAs(imagePath);

                            iTextSharp.text.Image image = iTextSharp.text.Image.GetInstance(imagePath);
                            float maxWidth = PageSize.A4.Width - 50;
                            float maxHeight = PageSize.A4.Height - 50;
                            image.ScaleToFit(maxWidth, maxHeight);
                            document.Add(image);
                        }

                        document.Close();
                    }

                    lblMessage.ForeColor = System.Drawing.Color.Green;
                    lblMessage.Text = "PDF created successfully! <a href='" + ResolveUrl("~/Uploads/" + Path.GetFileName(outputPdfPath)) + "' target='_blank'>Download Here</a>";
                }
                catch (Exception ex)
                {
                    lblMessage.Text = "Error: " + ex.Message;
                }
            }
            else
            {
                lblMessage.Text = "Please upload JPG images.";
            }
        }
    }
}
