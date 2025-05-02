<%@ Page Title="" Language="C#" MasterPageFile="~/PDF/PDF.Master" AutoEventWireup="true" CodeBehind="AddBackground.aspx.cs" Inherits="PDFconvertor.PDF.AddBackground" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
      <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&display=swap" rel="stylesheet" />
    <style>
       

        .container {
            background: #fff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            width: 400px;
            text-align: center;
        }

        .container input[type="file"],
        .container input[type="color"] {
            margin: 10px 0;
            display: block;
            width: 100%;
        }

      .container canvas {
    margin-top: 20px;
    max-width: 100%;
    border: 1px solid #ddd;
    background: #f5f5f5;
}

        .container button {
            background: #366bcdd2;
            color: #fff;
            padding: 12px 20px;
            border: none;
            margin-top: 15px;
            border-radius: 5px;
            cursor: pointer;
            text-transform: uppercase;
            font-weight: 500;
        }

        .container button:hover {
            background: #305cb9;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
   
        <h2>Add Background to Image</h2>

        <label>Select Foreground Image:</label>
        <input type="file" id="foregroundInput" accept="image/*" />

        <label>Select Background Color:</label>
        <input type="color" id="bgColorInput" value="#ffffff" />

        <label>Or Upload Background Image:</label>
        <input type="file" id="bgImageInput" accept="image/*" />

        <button type="button" onclick="combineImages()">Preview</button>
        <canvas id="canvas" width="400" height="400"></canvas>
        <button type="button" onclick="downloadImage()">Download</button>
   

    <script>
        let fgImage = null;
        let bgImage = null;

        document.getElementById("foregroundInput").addEventListener("change", function (e) {
            const reader = new FileReader();
            reader.onload = function (event) {
                fgImage = new Image();
                fgImage.onload = function () {
                    console.log("Foreground loaded");
                };
                fgImage.src = event.target.result;
            };
            reader.readAsDataURL(e.target.files[0]);
        });

        document.getElementById("bgImageInput").addEventListener("change", function (e) {
            const reader = new FileReader();
            reader.onload = function (event) {
                bgImage = new Image();
                bgImage.onload = function () {
                    console.log("Background loaded");
                };
                bgImage.src = event.target.result;
            };
            reader.readAsDataURL(e.target.files[0]);
        });

        function combineImages() {
            const canvas = document.getElementById("canvas");
            const ctx = canvas.getContext("2d");

            const bgColor = document.getElementById("bgColorInput").value;
            ctx.fillStyle = bgColor;
            ctx.fillRect(0, 0, canvas.width, canvas.height);

            if (bgImage) {
                ctx.drawImage(bgImage, 0, 0, canvas.width, canvas.height);
            }

            if (fgImage) {
                ctx.drawImage(fgImage, 0, 0, canvas.width, canvas.height);
            }
        }

        function downloadImage() {
            const canvas = document.getElementById("canvas");
            const a = document.createElement("a");
            a.href = canvas.toDataURL("image/png");
            a.download = "image_with_background.png";
            a.click();
        }
    </script>
</asp:Content>
