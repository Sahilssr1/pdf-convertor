<%@ Page Title="" Language="C#" MasterPageFile="~/PDF/PDF.Master" AutoEventWireup="true" CodeBehind="compressPdf.aspx.cs" Inherits="PDFconvertor.PDF.compressPdf" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="https://unpkg.com/pdf-lib/dist/pdf-lib.min.js"></script>

    <style>
        .container {
            width: 400px;
            margin: 50px auto;
            padding: 25px;
            background: #ffffff;
            text-align: center;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            font-family: Arial, sans-serif;
        }

        h2 {
            color: #2c3e50;
            margin-bottom: 20px;
            font-size: 24px;
        }

        .upload-section {
            margin: 20px 0;
        }

        .file-input {
            width: 100%;
            padding: 12px;
            border: 2px dashed #ced4da;
            border-radius: 8px;
            background: #f8f9fa;
            font-size: 14px;
            cursor: pointer;
            transition: border-color 0.3s;
        }

        .file-input:hover {
            border-color: #007bff;
            background: #e9ecef;
        }

        .btn {
            background: #007bff;
            color: white;
            padding: 12px 20px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 16px;
            width: 100%;
            transition: background 0.3s;
        }

        .btn:hover {
            background: #0056b3;
        }

        .message {
            margin-top: 15px;
            font-size: 14px;
            padding: 10px;
            border-radius: 5px;
            display: block;
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

        .upload-wrapper {
            position: relative;
        }

        .upload-label {
            display: block;
            font-size: 14px;
            color: #495057;
            margin-bottom: 5px;
            text-align: left;
        }

        @media (max-width: 450px) {
            .container {
                width: 90%;
                padding: 15px;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

        <h2>Compress PDF</h2>

        <div class="upload-section">
            <div class="upload-wrapper">
                <label class="upload-label" for="pdfFile">Upload PDF to Compress</label>
                <input type="file" id="pdfFile" accept="application/pdf" class="file-input" />
            </div>
        </div>

        <button id="btnCompress" class="btn" onclick="compressPDF()">Compress PDF</button>

        <div id="lblMessage" class="message"></div>
    

    <script>
        async function compressPDF() {
            const fileInput = document.getElementById('pdfFile');
            const messageDiv = document.getElementById('lblMessage');

            // Reset message
            messageDiv.innerHTML = "";
            messageDiv.className = "message";

            // Validate input
            if (!fileInput.files || fileInput.files.length === 0) {
                messageDiv.className = "message error";
                messageDiv.innerHTML = "❌ Please upload a PDF file.";
                return;
            }

            const file = fileInput.files[0];
            if (file.type !== "application/pdf") {
                messageDiv.className = "message error";
                messageDiv.innerHTML = "❌ Please upload a valid PDF file.";
                return;
            }

            try {
                // Read the uploaded PDF
                const originalBytes = await file.arrayBuffer();
                const originalSize = originalBytes.byteLength / 1024; // KB
                const pdfDoc = await PDFLib.PDFDocument.load(originalBytes);

                // Compress images by re-encoding
                const pages = pdfDoc.getPages();
                for (const page of pages) {
                    const images = page.node.Resources?.XObject?.values() || [];
                    for (const img of images) {
                        if (img instanceof PDFLib.PDFImage) {
                            const width = img.Width;
                            const height = img.Height;
                            const originalData = await img.decode();

                            // Convert to JPEG with reduced quality
                            const newImage = await pdfDoc.embedJpg(originalData);
                            const ref = newImage.ref;
                            page.node.Resources.XObject.set(img.Name, ref);
                        }
                    }
                }

                // Save with compression
                const compressedBytes = await pdfDoc.save({
                    useObjectStreams: true, // Compress object streams
                    updateFieldAppearances: false // Skip unnecessary updates
                });
                const compressedSize = compressedBytes.byteLength / 1024; // KB

                // Create download
                const blob = new Blob([compressedBytes], { type: 'application/pdf' });
                const url = URL.createObjectURL(blob);
                const a = document.createElement('a');
                a.href = url;
                a.download = `Compressed_${file.name}`;
                document.body.appendChild(a);
                a.click();
                document.body.removeChild(a);
                URL.revokeObjectURL(url);

                // Success message with size info
                messageDiv.className = "message success";
                messageDiv.innerHTML = `✅ PDF compressed successfully! Original: ${originalSize.toFixed(2)} KB, Compressed: ${compressedSize.toFixed(2)} KB`;
            } catch (error) {
                console.error(error);
                messageDiv.className = "message error";
                messageDiv.innerHTML = "❌ Error compressing PDF: " + error.message;
            }
        }
    </script>
</asp:Content>