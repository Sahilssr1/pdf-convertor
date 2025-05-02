<%@ Page Title="" Language="C#" MasterPageFile="~/PDF/PDF.Master" AutoEventWireup="true" CodeBehind="addTextToImage.aspx.cs" Inherits="PDFconvertor.PDF.addTextToImage" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet" />
    <style>
        .container {
            width: 450px;
            margin: 50px auto;
            padding: 20px;
            background: #fff;
            text-align: center;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            font-family: 'Poppins', sans-serif;
        }

        .container input, .container select, .container button {
            width: 100%;
            margin: 8px 0;
            padding: 8px;
            font-size: 14px;
            border-radius: 5px;
            border: 1px solid #ddd;
            box-sizing: border-box;
        }

        .text-section {
            margin: 10px 0;
        }

        canvas {
            margin-top: 15px;
            max-width: 100%;
            border: 1px solid #ccc;
        }

        .btn {
            background-color: #4a90e2;
            color: white;
            border: none;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .btn:hover {
            background-color: #357abd;
        }

        .add-btn {
            background-color: #5cb85c;
            margin-top: 5px;
        }

        .add-btn:hover {
            background-color: #4cae4c;
        }

        .input-group {
            display: flex;
            gap: 10px;
        }

        .input-group input {
            flex: 1;
        }

        .dynamic-text {
            margin: 5px 0;
            padding: 8px;
            width: 100%;
            border-radius: 5px;
            border: 1px solid #ddd;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
   
        <h2>Add Text on Image</h2>
        <input type="file" id="imageInput" accept="image/*" runat="server" />
        
        <div class="text-section" id="textSections">
            <asp:TextBox ID="customText1" runat="server" placeholder="Enter your text here" CssClass="dynamic-text" />
        </div>
        <asp:Button ID="btnAddAnother" runat="server" CssClass="btn add-btn" Text="+ Add Another Text" OnClientClick="return addAnotherText();" />

        <input type="color" id="textColor" runat="server" value="#000000" />
        <asp:TextBox ID="fontSize" runat="server" Text="30" TextMode="Number" min="10" placeholder="Font Size" />

        <asp:Button ID="btnAddText" runat="server" CssClass="btn" Text="Add Text" OnClientClick="return addText();" />
        <canvas id="canvas" runat="server"></canvas>
        <asp:Button ID="btnDownload" runat="server" CssClass="btn" Text="Download Image" OnClientClick="return downloadImage();" />
 

    <script type="text/javascript">
        document.addEventListener('DOMContentLoaded', function () {
            const imageInput = document.getElementById('<%= imageInput.ClientID %>');
            const canvas = document.getElementById('<%= canvas.ClientID %>');
            const ctx = canvas.getContext('2d');
            let img = new Image();
            let imgLoaded = false;
            let textSections = document.getElementById('textSections');

            imageInput.addEventListener('change', function (e) {
                const file = e.target.files[0];
                if (!file) return;

                const reader = new FileReader();
                reader.onload = function (event) {
                    img.onload = function () {
                        canvas.width = img.width;
                        canvas.height = img.height;
                        ctx.drawImage(img, 0, 0);
                        imgLoaded = true;
                    };
                    img.src = event.target.result;
                };
                reader.readAsDataURL(file);
            });

            window.addText = function () {
                if (!imgLoaded) {
                    alert("Upload an image first.");
                    return false;
                }

                ctx.clearRect(0, 0, canvas.width, canvas.height);
                ctx.drawImage(img, 0, 0);

                const textInputs = textSections.getElementsByClassName('dynamic-text');
                const color = document.getElementById('<%= textColor.ClientID %>').value;
                const fontSize = parseInt(document.getElementById('<%= fontSize.ClientID %>').value);

                ctx.fillStyle = color;
                ctx.textAlign = "center";
                for (let i = 0; i < textInputs.length; i++) {
                    const text = textInputs[i].value || `Text ${i + 1}`;
                    ctx.font = `${fontSize}px Poppins`;
                    ctx.fillText(text, canvas.width / 2, canvas.height - (40 * (textInputs.length - i)));
                }
                return false;
            };

            window.addAnotherText = function () {
                const inputCount = textSections.getElementsByClassName('dynamic-text').length + 1;
                const newInput = document.createElement('div');
                newInput.className = 'text-section';
                newInput.innerHTML = `<input type="text" class="dynamic-text" placeholder="Enter your text here" />`;
                textSections.appendChild(newInput);
                return false;
            };

            window.downloadImage = function () {
                if (!imgLoaded) {
                    alert("Upload an image and add text first.");
                    return false;
                }

                const link = document.createElement("a");
                link.download = "image_with_text.png";
                link.href = canvas.toDataURL("image/png");
                link.click();
                return false;
            };
        });
    </script>
</asp:Content>