<%@ Page Title="" Language="C#" MasterPageFile="~/PDF/PDF.Master" AutoEventWireup="true" CodeBehind="mergePdf.aspx.cs" Inherits="PDFconvertor.PDF.mergePdf" %>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

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
            padding: 10px;
            border: 2px dashed #ced4da;
            border-radius: 8px;
            background: #f8f9fa;
            margin-bottom: 15px;
            font-size: 14px;
            cursor: pointer;
        }

        .file-input:hover {
            border-color: #007bff;
            background: #e9ecef;
        }

        .add-more-btn {
            background: #28a745;
            color: white;
            padding: 8px 15px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            margin: 10px 0;
            transition: background 0.3s;
        }

        .add-more-btn:hover {
            background: #218838;
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

        .hidden {
            display: none;
        }

        @media (max-width: 450px) {
            .container {
                width: 90%;
                padding: 15px;
            }
        }
    </style>

   
        <h2>Merge PDFs</h2>

        <div class="upload-section">
            <div class="upload-wrapper">
                <asp:Label ID="lblUpload1" runat="server" CssClass="upload-label" Text="Upload First PDF"></asp:Label>
                <asp:FileUpload ID="fileUpload1" runat="server" CssClass="file-input" />
            </div>
            <div class="upload-wrapper">
                <asp:Label ID="lblUpload2" runat="server" CssClass="upload-label" Text="Upload Second PDF"></asp:Label>
                <asp:FileUpload ID="fileUpload2" runat="server" CssClass="file-input" />
            </div>
            <div class="upload-wrapper hidden" id="upload3Wrapper" runat="server">
                <asp:Label ID="lblUpload3" runat="server" CssClass="upload-label" Text="Upload Third PDF"></asp:Label>
                <asp:FileUpload ID="fileUpload3" runat="server" CssClass="file-input" />
            </div>
            <div class="upload-wrapper hidden" id="upload4Wrapper" runat="server">
                <asp:Label ID="lblUpload4" runat="server" CssClass="upload-label" Text="Upload Fourth PDF"></asp:Label>
                <asp:FileUpload ID="fileUpload4" runat="server" CssClass="file-input" />
            </div>
            <asp:Button ID="btnAddMore" runat="server" Text="Add More PDF" CssClass="add-more-btn" OnClientClick="return showNextUpload();" CausesValidation="false" />
        </div>

        <asp:Button ID="btnMerge" runat="server" Text="Merge PDFs" CssClass="btn" OnClick="btnMerge_Click" />

        <!-- Label to display error/success messages -->
        <asp:Label ID="lblMessage" runat="server" CssClass="message"></asp:Label>
   

    <script>
        var currentUpload = 2;

        function showNextUpload() {
            if (currentUpload < 4) {
                currentUpload++;
                var wrapper = document.getElementById('<%= upload3Wrapper.ClientID %>');
                if (currentUpload === 4) {
                    wrapper = document.getElementById('<%= upload4Wrapper.ClientID %>');
                    document.getElementById('<%= btnAddMore.ClientID %>').style.display = 'none';
                }
                if (wrapper) {
                    wrapper.classList.remove('hidden');
                }
            }
            return false; // Prevent postback
        }
    </script>

</asp:Content>
