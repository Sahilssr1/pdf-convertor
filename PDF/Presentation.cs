using System;
using Aspose.Pdf;

namespace PDFconvertor.PDF
{
    internal class Presentation
    {
        private string pptPath;

        public Presentation(string pptPath)
        {
            this.pptPath = pptPath;
        }

        internal void Save(string pdfFilePath, SaveFormat pdf)
        {
            throw new NotImplementedException();
        }
    }
}