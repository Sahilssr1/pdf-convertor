<%@ Page Title="" Language="C#" MasterPageFile="~/PDF/PDF.Master" AutoEventWireup="true" CodeBehind="pdfToWord.aspx.cs" Inherits="PDFconvertor.PDF.pdfToWord" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        

        .container {
            background: #fff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            width: 400px;
            text-align: center;
        }

        h1 {
            font-size: 24px;
            margin-bottom: 10px;
        }

        p {
            font-size: 16px;
            color: #666;
            margin-bottom: 20px;
        }

        .upload-box {
            border: 2px dashed #ccc;
            padding: 30px 20px;
            border-radius: 10px;
            cursor: pointer;
            transition: border-color 0.3s ease;
            margin-bottom: 20px;
        }

        .upload-box:hover {
            border-color: #366bcd;
        }

        .upload-label {
            display: block;
            cursor: pointer;
        }

        .drag-text {
            font-size: 16px;
            color: #666;
        }

        .file-name {
            font-size: 14px;
            color: #007bff;
            margin-top: 10px;
            display: block;
        }

        .btn {
            background: #366bcdd2;
            color: #fff;
            padding: 12px 20px;
            border: none;
            margin-top: 15px;
            border-radius: 5px;
            cursor: pointer;
            text-transform: uppercase;
            font-weight: 500;
            width: 100%;
        }

        .btn:hover {
            background: #305cb9;
        }

        .status {
            margin-top: 15px;
            font-size: 14px;
            color: #666;
        }

        .download-link {
            display: inline-block;
            margin-top: 15px;
            color: #366bcd;
            text-decoration: none;
            font-size: 16px;
        }

        .download-link:hover {
            text-decoration: underline;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
      <h1>PDF to Word Converter</h1>
        <p>Convert your PDF files to Word documents easily.</p>
        <div class="upload-box" id="uploadBox">
            <input type="file" id="fileInput" accept=".pdf" hidden />
            <label for="fileInput" class="upload-label">
                <span class="drag-text">Drag & Drop or Click to Upload</span>
                <span class="file-name" id="fileName"></span>
            </label>
        </div>
        <button id="convertBtn" class="btn" disabled>Convert to Word</button>
        <div class="status" id="status"></div>
        <a id="downloadLink" class="download-link" style="display: none;">Download Word File</a>
     <!-- Import required libraries -->
     <script src="https://cdnjs.cloudflare.com/ajax/libs/pdf-lib/1.17.1/pdf-lib.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/docx@7.1.2/build/index.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdf.js/3.11.174/pdf.min.js"></script>


    <script>
        const fileInput = document.getElementById("fileInput");
        const uploadBox = document.getElementById("uploadBox");
        const fileName = document.getElementById("fileName");
        const convertBtn = document.getElementById("convertBtn");
        const statusText = document.getElementById("status");
        const downloadLink = document.getElementById("downloadLink");

        let selectedFile = null;

        // Handle file selection
        fileInput.addEventListener("change", (e) => {
            const file = e.target.files[0];
            handleFile(file);
        });

        // Handle drag and drop
        uploadBox.addEventListener("dragover", (e) => {
            e.preventDefault();
            e.stopPropagation();
            uploadBox.style.borderColor = "#007bff";
        });

        uploadBox.addEventListener("dragleave", () => {
            uploadBox.style.borderColor = "#ccc";
        });

        uploadBox.addEventListener("drop", (e) => {
            e.preventDefault();
            e.stopPropagation();
            uploadBox.style.borderColor = "#ccc";

            const file = e.dataTransfer.files[0];
            handleFile(file);
        });

        // Handle file validation and UI updates
        function handleFile(file) {
            if (!file) {
                fileName.textContent = "";
                convertBtn.disabled = true;
                return;
            }

            if (file.type === "application/pdf") {
                selectedFile = file;
                fileName.textContent = selectedFile.name;
                convertBtn.disabled = false;
                statusText.textContent = "";
                downloadLink.hidden = true;
            } else {
                alert("Please upload a valid PDF file.");
                fileInput.value = "";
                convertBtn.disabled = true;
            }
        }

        // Handle conversion
        convertBtn.addEventListener("click", async () => {
            if (!selectedFile) {
                alert("Please upload a PDF file first.");
                return;
            }

            convertBtn.disabled = true;
            statusText.textContent = "Converting...";

            try {
                const reader = new FileReader();
                reader.onload = async function (event) {
                    const pdfData = new Uint8Array(event.target.result);

                    const pdf = await pdfjsLib.getDocument({ data: pdfData }).promise;
                    let paragraphs = [];

                    for (let i = 1; i <= pdf.numPages; i++) {
                        const page = await pdf.getPage(i);
                        const textContent = await page.getTextContent();
                        const pageText = textContent.items.map(item => item.str).join(' ').trim();

                        if (pageText) {
                            paragraphs.push(
                                new docx.Paragraph({
                                    children: [
                                        new docx.TextRun({
                                            text: pageText,
                                            font: "Arial",
                                            size: 24
                                        })
                                    ],
                                    spacing: {
                                        after: 300
                                    }
                                })
                            );
                        }
                    }

                    if (paragraphs.length === 0) {
                        paragraphs.push(new docx.Paragraph({
                            children: [
                                new docx.TextRun({
                                    text: "No extractable text found in this PDF.",
                                    font: "Arial",
                                    bold: true,
                                    color: "FF0000",
                                    size: 28
                                })
                            ]
                        }));
                    }

                    const doc = new docx.Document({
                        sections: [{
                            properties: {},
                            children: paragraphs
                        }]
                    });

                    const docBlob = await docx.Packer.toBlob(doc);
                    const docUrl = URL.createObjectURL(docBlob);

                    downloadLink.href = docUrl;
                    downloadLink.download = selectedFile.name.replace(".pdf", ".docx");
                    downloadLink.style.display = '';
                    statusText.textContent = "Conversion complete!";
                    convertBtn.disabled = false;
                };

                reader.readAsArrayBuffer(selectedFile);
            } catch (error) {
                console.error("Conversion failed:", error);
                statusText.textContent = "Conversion failed. Please try again.";
                convertBtn.disabled = false;
            }
        });

    </script>
</asp:Content>
