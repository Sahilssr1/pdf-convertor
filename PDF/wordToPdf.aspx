<%@ Page Title="" Language="C#" MasterPageFile="~/PDF/PDF.Master" AutoEventWireup="true" CodeBehind="wordToPdf.aspx.cs" Inherits="PDFconvertor.PDF.wordToPdf" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .container {
            width: 350px;
            margin: 50px auto;
            padding: 20px;
            background: #fff;
            text-align: center;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        h2 {
            color: #333;
        }

        .upload-section {
            margin: 15px 0;
        }

        .file-input {
            width: 90%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }

        .btn {
            background: #007bff;
            color: white;
            padding: 10px 15px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: 0.3s;
            font-size: 16px;
        }

        .btn:hover {
            background: #0056b3;
        }

        .message {
            margin-top: 10px;
            font-size: 14px;
        }

        .success {
            color: green;
        }

        .error {
            color: red;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <%--<div class="container">--%>
        <h2>Convert Word to PDF</h2>

        <div class="upload-section">
            <asp:FileUpload ID="fileUpload" runat="server" CssClass="file-input" />
        </div>

        <asp:Button ID="btnConvert" runat="server" Text="Convert to PDF" CssClass="btn" OnClick="btnConvert_Click" />

        <asp:Label ID="lblMessage" runat="server" CssClass="message"></asp:Label>
   <%-- </div>--%>
</asp:Content>

