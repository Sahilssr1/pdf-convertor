<%@ Page Title="" Language="C#" MasterPageFile="~/PDF/PDF.Master" AutoEventWireup="true" CodeBehind="splitPdf.aspx.cs" Inherits="PDFconvertor.PDF.splitPdf" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="https://unpkg.com/pdf-lib/dist/pdf-lib.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdf.js/2.9.359/pdf.min.js"></script>

    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f4f6f8;
            padding: 20px;
            text-align: center;
        }

        .container {
            background: #ffffff;
            padding: 25px;
            border-radius: 12px;
            width: 500px;
            margin: auto;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
        }

        h2 {
            color: #2c3e50;
            margin-bottom: 20px;
        }

        .mode-toggle {
            margin-bottom: 15px;
        }

        .mode-toggle label {
            margin: 0 10px;
            font-size: 16px;
        }

        .file-input {
            padding: 10px;
            border: 2px dashed #ced4da;
            border-radius: 8px;
            width: 100%;
            box-sizing: border-box;
            margin-bottom: 15px;
            background: #f8f9fa;
        }

        .preview-container {
            margin: 15px 0;
            max-height: 300px;
            overflow-y: auto;
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 10px;
            background: #fafafa;
        }

        .page-preview {
            display: inline-block;
            margin: 10px;
            text-align: center;
        }

        .page-preview canvas {
            border: 1px solid #ccc;
            border-radius: 4px;
            max-width: 100px;
        }

        .page-preview label {
            display: block;
            margin-top: 5px;
            font-size: 12px;
        }

        .btn {
            padding: 10px 20px;
            background: #007bff;
            color: white;
            border: none;
            border-radius: 6px;
            margin: 10px 5px;
            cursor: pointer;
            font-size: 14px;
        }

        .btn:hover {
            background: #0056b3;
        }

        .select-all {
            margin: 10px 0;
            text-align: left;
        }

        .message {
            margin: 15px 0;
            padding: 10px;
            border-radius: 5px;
            font-size: 14px;
        }

        .success {
            color: #155724;
            background: #d4edda;
            border: 1px solid #c3e6cb;
        }

        .error {
            color: #721c24;
            background: #f8d7da;
            border: 1px solid #f5c6cb;
        }

        @media (max-width: 550px) {
            .container {
                width: 90%;
                padding: 15px;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
   
        <h2>PDF Editor</h2>

        <div class="mode-toggle">
            <label><input type="radio" name="mode" value="split" checked onclick="toggleMode()"> Split PDF</label>
            <label><input type="radio" name="mode" value="cut" onclick="toggleMode()"> Cut Pages</label>
        </div>

        <input type="file" id="pdfFile" accept="application/pdf" class="file-input">

        <div id="previewContainer" class="preview-container"></div>

        <div class="select-all">
            <label>
                <input type="checkbox" id="selectAllPages" />
                <strong>Select / Deselect All Pages</strong>
            </label>
        </div>

        <button class="btn" onclick="processPDF()">Process PDF</button>
        <div class="message" id="message"></div>
  
    <script>
        let uploadedPDFBytes = null;
        let totalPages = 0;

        const fileInput = document.getElementById("pdfFile");
        const previewContainer = document.getElementById("previewContainer");
        const selectAllCheckbox = document.getElementById("selectAllPages");
        const messageDiv = document.getElementById("message");

        // Load PDF.js worker
        pdfjsLib.GlobalWorkerOptions.workerSrc = 'https://cdnjs.cloudflare.com/ajax/libs/pdf.js/2.9.359/pdf.worker.min.js';

        fileInput.addEventListener("change", async function () {
            messageDiv.innerHTML = "";
            previewContainer.innerHTML = "";
            selectAllCheckbox.checked = false;

            const file = fileInput.files[0];
            if (!file || file.type !== "application/pdf") {
                messageDiv.className = "message error";
                messageDiv.innerHTML = "❌ Please upload a valid PDF.";
                return;
            }

            uploadedPDFBytes = await file.arrayBuffer();

            // Load PDF for preview
            const pdfDoc = await PDFLib.PDFDocument.load(uploadedPDFBytes);
            totalPages = pdfDoc.getPageCount();

            // Render page thumbnails
            const pdf = await pdfjsLib.getDocument({ data: uploadedPDFBytes }).promise;
            previewContainer.innerHTML = '<div id="pagesGrid"></div>';
            const pagesGrid = document.getElementById("pagesGrid");
            pagesGrid.style.display = 'grid';
            pagesGrid.style.gridTemplateColumns = 'repeat(auto-fit, minmax(120px, 1fr))';
            pagesGrid.style.gap = '10px';

            for (let i = 1; i <= totalPages; i++) {
                const page = await pdf.getPage(i);
                const viewport = page.getViewport({ scale: 0.3 });

                const canvas = document.createElement('canvas');
                canvas.width = viewport.width;
                canvas.height = viewport.height;

                const context = canvas.getContext('2d');
                await page.render({ canvasContext: context, viewport: viewport }).promise;

                const pageItem = document.createElement('div');
                pageItem.className = 'page-preview';
                pageItem.innerHTML = `
                    <label>
                        <input type="checkbox" value="${i}" class="page-checkbox">
                        Page ${i}
                    </label>
                `;
                pageItem.insertBefore(canvas, pageItem.firstChild);
                pagesGrid.appendChild(pageItem);
            }

            // Update Select All
            selectAllCheckbox.addEventListener("change", function () {
                const checkboxes = document.querySelectorAll('.page-checkbox');
                checkboxes.forEach(cb => cb.checked = selectAllCheckbox.checked);
            });

            messageDiv.className = "message success";
            messageDiv.innerHTML = `✅ PDF uploaded with ${totalPages} pages. Select pages to ${getMode() === 'split' ? 'split' : 'cut'}.`;
        });

        function toggleMode() {
            if (!uploadedPDFBytes) return;
            messageDiv.className = "message";
            messageDiv.innerHTML = `Select pages to ${getMode() === 'split' ? 'split' : 'cut'}.`;
        }

        function getMode() {
            return document.querySelector('input[name="mode"]:checked').value;
        }

        async function processPDF() {
            const selectedCheckboxes = document.querySelectorAll('.page-checkbox:checked');
            const selectedPages = Array.from(selectedCheckboxes).map(cb => parseInt(cb.value));

            if (!uploadedPDFBytes || selectedPages.length === 0) {
                messageDiv.className = "message error";
                messageDiv.innerHTML = "❌ Please upload a PDF and select at least one page.";
                return;
            }

            try {
                const originalDoc = await PDFLib.PDFDocument.load(uploadedPDFBytes);
                const newDoc = await PDFLib.PDFDocument.create();
                const mode = getMode();

                if (mode === "split") {
                    // Split: Keep selected pages
                    for (let pageNum of selectedPages) {
                        const [copiedPage] = await newDoc.copyPages(originalDoc, [pageNum - 1]);
                        newDoc.addPage(copiedPage);
                    }
                } else {
                    // Cut: Keep all pages except selected ones
                    for (let i = 1; i <= totalPages; i++) {
                        if (!selectedPages.includes(i)) {
                            const [copiedPage] = await newDoc.copyPages(originalDoc, [i - 1]);
                            newDoc.addPage(copiedPage);
                        }
                    }
                }

                if (newDoc.getPageCount() === 0) {
                    messageDiv.className = "message error";
                    messageDiv.innerHTML = "❌ No pages left after processing.";
                    return;
                }

                const newPdfBytes = await newDoc.save();
                const blob = new Blob([newPdfBytes], { type: 'application/pdf' });
                const downloadUrl = URL.createObjectURL(blob);

                // Trigger download
                const a = document.createElement('a');
                a.href = downloadUrl;
                a.download = mode === "split" ? "Split_PDF.pdf" : "Cut_PDF.pdf";
                document.body.appendChild(a);
                a.click();
                document.body.removeChild(a);

                // Show success message
                messageDiv.className = "message success";
                messageDiv.innerHTML = `
                    ✅ ${mode === "split" ? "Split" : "Cut"} successful!<br/>
                    <a class="btn" href="${downloadUrl}" download="${mode === "split" ? "Split_PDF.pdf" : "Cut_PDF.pdf"}" target="_blank">
                        📄 Download Again
                    </a>
                `;
            } catch (error) {
                console.error(error);
                messageDiv.className = "message error";
                messageDiv.innerHTML = "❌ Error while processing the PDF.";
            }
        }
    </script>
</asp:Content>