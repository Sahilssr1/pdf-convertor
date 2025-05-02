using System;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;
using iTextSharp.text.pdf;
using iTextSharp.text;

namespace PDFconvertor.PDF
{
    public partial class rotatePdf : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnRotate_Click(object sender, EventArgs e)
        {
            if (fileUpload.HasFile)
            {
                try
                {
                    string fileName = Path.GetFileName(fileUpload.FileName);
                    string uploadDir = Server.MapPath("~/Uploads/");
                    string filePath = Path.Combine(uploadDir, fileName);

                    if (!Directory.Exists(uploadDir))
                    {
                        Directory.CreateDirectory(uploadDir);
                    }

                    fileUpload.SaveAs(filePath);

                    string outputFilePath = Path.Combine(uploadDir, "Rotated_" + fileName);
                    int rotationAngle = int.Parse(ddlRotationAngle.SelectedValue);

                    if (RotatePDF(filePath, outputFilePath, rotationAngle))
                    {
                        lblMessage.ForeColor = System.Drawing.Color.Green;
                        lblMessage.Text = "PDF rotated successfully! <a href='" + ResolveUrl("~/Uploads/Rotated_" + fileName) + "' target='_blank'>Download Here</a>";
                    }
                    else
                    {
                        lblMessage.Text = "Error rotating the PDF.";
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

        private bool RotatePDF(string inputPdf, string outputPdf, int angle)
        {
            try
            {
                PdfReader reader = new PdfReader(inputPdf);
                using (FileStream outputStream = new FileStream(outputPdf, FileMode.Create, FileAccess.Write, FileShare.None))
                {
                    PdfStamper stamper = new PdfStamper(reader, outputStream);

                    int totalPages = reader.NumberOfPages;
                    for (int i = 1; i <= totalPages; i++)
                    {
                        PdfDictionary pageDict = reader.GetPageN(i);
                        PdfNumber rotate = pageDict.GetAsNumber(PdfName.ROTATE);
                        int currentRotation = (rotate == null) ? 0 : rotate.IntValue;
                        pageDict.Put(PdfName.ROTATE, new PdfNumber((currentRotation + angle) % 360));
                    }

                    stamper.Close();
                }

                reader.Close();
                return true;
            }
            catch
            {
                return false;
            }
        }
    }
}
