<%@ Page Title="" Language="C#" MasterPageFile="~/PDF/PDF.Master" AutoEventWireup="true" CodeBehind="imageResizer.aspx.cs" Inherits="PDFconvertor.PDF.imageResizer" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&display=swap" rel="stylesheet" />
    <style>
        body {
            font-family: 'Poppins', sans-serif;
        }

        .container {
            width: 350px;
            margin: 50px auto;
            padding: 20px;
            background: #fff;
            text-align: center;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        /*.wrapper {
            width: 450px;
            background: #fff;
            border-radius: 10px;
            padding: 30px;
            margin: 50px auto;
        }*/

        .upload-box {
            height: 225px;
            border: 2px dashed #afafaf;
            border-radius: 5px;
            display: flex;
            justify-content: center;
            align-items: center;
            flex-direction: column;
            cursor: pointer;
            margin-bottom: 20px;
            text-align: center;
            overflow: hidden;
        }

        .upload-box img {
            display: none;
            max-width: 100%;
            max-height: 100%;
            object-fit: cover;
            border-radius: 5px;
        }

        .upload-box.active img {
            display: block;
        }

        .upload-box.active p {
            display: none;
        }

        .row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 15px;
        }

        .column {
            flex: 1;
            margin: 0 10px;
        }

        .column label {
            display: block;
            margin-bottom: 5px;
        }

        .column input[type="number"] {
            width: 100%;
            padding: 10px;
            border-radius: 5px;
            border: 1px solid #aaa;
            font-family: inherit;
        }

        .checkboxes {
            margin-top: 10px;
            font-size: 0.95rem;
            display: flex;
            justify-content: space-between;
        }

        .checkboxes .column {
            display: flex;
            align-items: center;
        }

        .checkboxes input {
            margin-right: 5px;
        }

        .download-btn {
            margin-top: 25px;
            width: 100%;
            padding: 12px;
            background: #366bcdd2;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 1rem;
            cursor: pointer;
            text-transform: uppercase;
            transition: background 0.3s;
        }

        .download-btn:hover {
            background: #305cb9;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
      <div class="wrapper">
        <div class="upload-box" onclick="document.getElementById('file').click()">
            <img src="" alt="Uploaded Image" id="imgDisplayed">
            <p>Click to Upload Image</p>
            <input type="file" id="file" accept="image/*" hidden>
        </div>

        <div class="content">
            <div class="row">
                <div class="column">
                    <label for="imWidth">Width (px)</label>
                    <input type="number" id="imWidth">
                </div>
                <div class="column">
                    <label for="imHeight">Height (px)</label>
                    <input type="number" id="imHeight">
                </div>
            </div>

            <div class="checkboxes row">
                <div class="column">
                    <input type="checkbox" id="ratio" checked>
                    <label for="ratio">Keep aspect ratio</label>
                </div>
               <div class="column">
    <label for="quality">Compression</label>
    <select id="quality">
        <option value="1">None</option>
        <option value="0.5" selected>50%</option>
        <option value="0.25">25%</option>
        <option value="0.1">10%</option>
    </select>
</div>

            </div>

            <button class="download-btn">Download</button>
        </div>
    </div>

    <script>
        const uploadBox = document.querySelector(".upload-box"),
            previewImg = document.getElementById("imgDisplayed"),
            fileInput = document.getElementById("file"),
            widthInput = document.getElementById("imWidth"),
            heightInput = document.getElementById("imHeight"),
            ratioInput = document.getElementById("ratio"),
            qualityInput = document.getElementById("quality"),
            downloadBtn = document.querySelector(".download-btn");

        let ogImageRatio;

        const loadFile = (e) => {
            const file = e.target.files[0];
            if (!file) return;
            previewImg.src = URL.createObjectURL(file);
            previewImg.onload = () => {
                widthInput.value = previewImg.naturalWidth;
                heightInput.value = previewImg.naturalHeight;
                ogImageRatio = previewImg.naturalWidth / previewImg.naturalHeight;
                uploadBox.classList.add("active");
            };
        };

        widthInput.addEventListener("input", () => {
            if (ratioInput.checked) {
                heightInput.value = Math.round(widthInput.value / ogImageRatio);
            }
        });

        heightInput.addEventListener("input", () => {
            if (ratioInput.checked) {
                widthInput.value = Math.round(heightInput.value * ogImageRatio);
            }
        });

        const resizeAndDownload = () => {
            const canvas = document.createElement("canvas");
            const ctx = canvas.getContext("2d");

            const width = parseInt(widthInput.value);
            const height = parseInt(heightInput.value);
            const quality = parseFloat(qualityInput.value); // updated line

            canvas.width = width;
            canvas.height = height;

            ctx.drawImage(previewImg, 0, 0, width, height);

            const a = document.createElement("a");
            a.href = canvas.toDataURL("image/jpeg", quality);
            a.download = `resized-${Date.now()}.jpg`;
            a.click();
        };

        downloadBtn.addEventListener("click", resizeAndDownload);
        fileInput.addEventListener("change", loadFile);
            </script>
</asp:Content>
