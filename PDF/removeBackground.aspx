<%@ Page Title="Remove Background" Language="C#" MasterPageFile="~/PDF/PDF.Master" AutoEventWireup="true" CodeBehind="RemoveBackground.aspx.cs" Inherits="PDFconvertor.PDF.RemoveBackground" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&display=swap" rel="stylesheet" />
  <style>
  

    .container {
        background: #fff;
        padding: 25px;
        border-radius: 14px;
        max-width: 700px;
        margin: auto;
        box-shadow: 0 4px 25px rgba(0, 0, 0, 0.08);
    }

    h2, h3 {
        text-align: center;
        color: #2c3e50;
        margin-bottom: 20px;
    }

    input[type="file"], input[type="color"] {
        width: 100%;
        padding: 10px;
        margin-top: 10px;
        border: 1px solid #ccc;
        border-radius: 8px;
        background-color: #fefefe;
    }

    .btn {
        background: #366bcd;
        color: white;
        border: none;
        padding: 12px;
        margin-top: 20px;
        border-radius: 8px;
        cursor: pointer;
        font-weight: 500;
        width: 100%;
        transition: background 0.3s;
    }

    .btn:hover {
        background: #2c58a0;
    }

    img, canvas {
        max-width: 100%;
        height: auto;
        border-radius: 10px;
        margin-top: 15px;
        display: block;
        margin-left: auto;
        margin-right: auto;
    }

    #statusText {
        text-align: center;
        font-size: 14px;
        margin-top: 10px;
        color: #888;
    }

    #downloadLink {
        display: none;
        text-align: center;
    }

    #addBackgroundSection {
        display: none;
        margin-top: 30px;
    }

    label {
        margin-top: 15px;
        font-weight: 500;
        display: block;
    }

    #previewContainer,
    #resultContainer,
    #canvasContainer {
        background: #fdfdfd;
        border: 1px solid #ddd;
        border-radius: 10px;
        padding: 15px;
        margin-top: 20px;
        display: none;
    }

    @media (max-width: 768px) {
        body {
            padding: 15px;
        }

        .btn {
            padding: 10px;
        }

        .container {
            padding: 20px;
        }
    }
</style>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    

    <h2>Remove Background</h2>
    <input type="file" id="imageUpload" accept="image/*" />

    <div id="previewContainer">
        <img id="previewImage" src="#" alt="Preview Image" />
    </div>

    <button type="button" class="btn" onclick="removeBackground()">Remove Background</button>
    <p id="statusText"></p>

    <div id="resultContainer">
        <img id="resultImage" src="#" alt="Result Image" />
        <a id="downloadLink" download="no-bg.png">
            <button type="button" class="btn">Download No-BG Image</button>
        </a>
    </div>

    <div id="addBackgroundSection">
        <h3>Add Background</h3>
        <label>Select Background Color:</label>
        <input type="color" id="bgColorInput" value="#ffffff" />

        <label>Or Upload Background Image:</label>
        <input type="file" id="bgImageInput" accept="image/*" />

        <button type="button" class="btn" onclick="combineImages()">Preview with Background</button>

        <div id="canvasContainer">
            <canvas id="canvas" width="400" height="400"></canvas>
        </div>

        <button type="button" class="btn" onclick="downloadFinal()">Download Final Image</button>
    </div>


  <script>
      let originalImage = null;
      let bgImage = null;
      let fgImageBlob = null;

      // Image Upload and Preview
      document.getElementById("imageUpload").addEventListener("change", function (e) {
          const reader = new FileReader();
          reader.onload = function (event) {
              originalImage = new Image();
              originalImage.onload = function () {
                  const img = document.getElementById("previewImage");
                  img.src = originalImage.src;
                  img.style.display = "block";
                  document.getElementById("previewContainer").style.display = "block";
              };
              originalImage.src = event.target.result;
          };
          reader.readAsDataURL(e.target.files[0]);
      });

      // Remove Background
      async function removeBackground() {
          const fileInput = document.getElementById("imageUpload");
          const file = fileInput.files[0];

          if (!file) {
              alert("Please select an image.");
              return;
          }

          document.getElementById("statusText").innerText = "Removing background...";
          const formData = new FormData();
          formData.append("image_file", file);

          const response = await fetch("https://api.remove.bg/v1.0/removebg", {
              method: "POST",
              headers: {
                  "X-Api-Key": "2we4qAmBFKvRbsLvMuGJZNXZ" // Replace with your actual key
              },
              body: formData
          });

          if (response.status === 200) {
              fgImageBlob = await response.blob();
              const imageUrl = URL.createObjectURL(fgImageBlob);

              const img = document.getElementById("resultImage");
              const download = document.getElementById("downloadLink");

              img.src = imageUrl;
              img.style.display = "block";
              document.getElementById("resultContainer").style.display = "block";

              download.href = imageUrl;
              download.style.display = "inline-block";

              document.getElementById("addBackgroundSection").style.display = "block";
              document.getElementById("statusText").innerText = "Background removed!";
          } else {
              const errorText = await response.text();
              document.getElementById("statusText").innerText = "Error: " + errorText;
          }
      }

      // Background Image Upload
      document.getElementById("bgImageInput").addEventListener("change", function (e) {
          const reader = new FileReader();
          reader.onload = function (event) {
              bgImage = new Image();
              bgImage.src = event.target.result;
          };
          reader.readAsDataURL(e.target.files[0]);
      });

      // Combine Foreground with Background
      function combineImages() {
          const canvas = document.getElementById("canvas");
          const ctx = canvas.getContext("2d");

          // Fill background color
          const bgColor = document.getElementById("bgColorInput").value;
          ctx.fillStyle = bgColor;
          ctx.fillRect(0, 0, canvas.width, canvas.height);

          // Draw background image if any
          if (bgImage) {
              ctx.drawImage(bgImage, 0, 0, canvas.width, canvas.height);
          }

          // Draw foreground image
          if (fgImageBlob) {
              const fgImg = new Image();
              fgImg.onload = function () {
                  ctx.drawImage(fgImg, 0, 0, canvas.width, canvas.height);
                  canvas.style.display = "block";
                  document.getElementById("canvasContainer").style.display = "block";
              };
              fgImg.src = URL.createObjectURL(fgImageBlob);
          }
      }

      // Download Final Combined Image
      function downloadFinal() {
          const canvas = document.getElementById("canvas");
          const a = document.createElement("a");
          a.href = canvas.toDataURL("image/png");
          a.download = "final_image.png";
          a.click();
      }
  </script>

</asp:Content>