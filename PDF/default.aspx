<%@ Page Title="PDF Converter" Language="C#" MasterPageFile="~/PDF/PDF.Master" AutoEventWireup="true" CodeBehind="default.aspx.cs" Inherits="PDFconvertor.PDF._default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: Arial, sans-serif;
        }

        body {
            background-color: #f5f5f5;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 40px 20px;
        }

        /* Header Styles */
        .header {
            text-align: center;
            margin-bottom: 40px;
        }

        .header h1 {
            font-size: 2.5rem;
            color: #333;
            margin-bottom: 10px;
        }

        .header p {
            font-size: 1.1rem;
            color: #666;
            line-height: 1.5;
        }

        /* Grid Styles */
        .grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
        }

        .card {
            background-color: #fff;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            text-align: center;
            transition: transform 0.2s;
            cursor: pointer;
        }

        .card:hover {
            transform: translateY(-5px);
        }

        .card .icon {
            font-size: 2rem;
            margin-bottom: 10px;
        }

        .card h3 {
            font-size: 1.2rem;
            color: #333;
            margin-bottom: 10px;
        }

        .card p {
            font-size: 0.9rem;
            color: #666;
            line-height: 1.4;
        }

        .new {
            background-color: #ff4d4d;
            color: #fff;
            font-size: 0.7rem;
            padding: 2px 6px;
            border-radius: 10px;
            margin-left: 5px;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .header h1 {
                font-size: 1.8rem;
            }

            .header p {
                font-size: 1rem;
            }

            .grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container">
        <!-- Header Section -->
        <header class="header">
            <h1>Every tool you need to work with PDFs in one place</h1>
            <p>Merge, split, compress, convert, rotate, unlock, watermark PDFs with just a few clicks.</p>
        </header>

        <!-- Grid Section -->
        <div class="grid">
            <!-- PDF Tools -->
            <div class="card" onclick="redirectTo('mergePdf')">
                <div class="icon">📜</div>
                <h3>Merge PDF</h3>
                <p>Combine PDFs in the order you want with the easiest PDF merger available.</p>
            </div>

            <div class="card" onclick="redirectTo('splitPdf')">
                <div class="icon">✂️</div>
                <h3>Split PDF</h3>
                <p>Split one page or a whole set for easy conversion into independent PDF files.</p>
            </div>

            <div class="card" onclick="redirectTo('compressPdf')">
                <div class="icon">📏</div>
                <h3>Compress PDF</h3>
                <p>Reduce file size while optimizing for maximal quality.</p>
            </div>

            <div class="card" onclick="redirectTo('pdfToWord')">
                <div class="icon">📝</div>
                <h3>PDF to Word</h3>
                <p>Easily convert PDFs into easy-to-edit DOC/DOCX documents.</p>
            </div>

            <div class="card" onclick="redirectTo('pdfToPpt')">
                <div class="icon">📊</div>
                <h3>PDF to PowerPoint</h3>
                <p>Turn your PDFs into easy-to-edit PPT and PPTX slideshows.</p>
            </div>

            <div class="card" onclick="redirectTo('pdfToExcel')">
                <div class="icon">📈</div>
                <h3>PDF to Excel</h3>
                <p>Convert PDFs to Excel spreadsheets in seconds.</p>
            </div>

            <div class="card" onclick="redirectTo('wordToPdf')">
                <div class="icon">📄</div>
                <h3>Word to PDF</h3>
                <p>Make DOC and DOCX files easy to read by converting them to PDF.</p>
            </div>

            <div class="card" onclick="redirectTo('jpgToPdf')">
                <div class="icon">🖼️</div>
                <h3>JPG to PDF</h3>
                <p>Convert JPG images to PDF in seconds.</p>
            </div>

          <%--  <div class="card" onclick="redirectTo('signPdf')">
                <div class="icon">✍️</div>
                <h3>Sign PDF</h3>
                <p>Sign PDF or request electronic signatures from others.</p>
            </div>--%>

            <div class="card" onclick="redirectTo('watermarkPdf')">
                <div class="icon">💧</div>
                <h3>Watermark PDF</h3>
                <p>Stamp an image or text over your PDF in seconds.</p>
            </div>

            <div class="card" onclick="redirectTo('rotatePdf')">
                <div class="icon">🔄</div>
                <h3>Rotate PDF</h3>
                <p>Rotate PDF files to your preference.</p>
            </div>

            <div class="card" onclick="redirectTo('unlockPdf')">
                <div class="icon">🔓</div>
                <h3>Unlock PDF</h3>
                <p>Remove password protection from your PDFs.</p>
            </div>

            <div class="card" onclick="redirectTo('protectPdf')">
                <div class="icon">🔒</div>
                <h3>Protect PDF</h3>
                <p>Encrypt your PDF files with a password.</p>
               </div>

            <div class="card" onclick="redirectTo('removeBackground')">
            <div class="icon">🖼️</div>
            <h3>Remove Background</h3>
            <p>Remove the background from your images easily.</p>
            </div>

            <div class="card" onclick="redirectTo('AddBackground')">
           <div class="icon">🖼️</div>
           <h3>Add Background</h3>
           <p>Add a custom background to your images easily.</p>
           </div>

            <div class="card" onclick="redirectTo('imageResizer')">
            <div class="icon">📐</div>
            <h3>Image Resizer</h3>
            <p>Resize your images quickly and easily.</p>
            </div>

            <div class="card" onclick="redirectTo('addTextToImage')">
            <div class="icon">✏️</div>
            <h3>Add Text</h3>
            <p>Add custom text inside your photos easily.</p>
            </div>

         

           
<script>
    function redirectTo(page) {
        window.location.href = page + ".aspx";
    }
</script>


        </div>
    </div>

    <!-- JavaScript Redirection Function -->
    <script>
        function redirectTo(page) {
            window.location.href = page + ".aspx";
        }
    </script>
</asp:Content>
