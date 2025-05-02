<%@ Page Title="" Language="C#" MasterPageFile="~/PDF/PDF.Master" AutoEventWireup="true" CodeBehind="watermarkPdf.aspx.cs" Inherits="PDFconvertor.PDF.watermarkPdf" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
 <style>
        .container {
            max-width: 600px;
            margin: 40px auto;
            padding: 20px;
            background: white;
            border-radius: 8px;
            box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            font-weight: bold;
        }
        .btn {
            background: #007bff;
            color: white;
            border: none;
            padding: 10px 15px;
            cursor: pointer;
            border-radius: 5px;
        }
        .btn:hover {
            background: #0056b3;
        }
        .message {
            margin-top: 15px;
            font-size: 16px;
            font-weight: bold;
            color: green;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
        <h2>Watermark Your PDF</h2>
        
        <div class="form-group">
            <label>Upload PDF File:</label>
            <asp:FileUpload ID="fileUpload" runat="server" />
        </div>

        <div class="form-group">
            <label>Watermark Text:</label>
            <asp:TextBox ID="txtWatermark" runat="server" CssClass="form-control"></asp:TextBox>
        </div>

        <asp:Button ID="btnUpload" runat="server" CssClass="btn" Text="Add Watermark" OnClick="btnUpload_Click" />
        
        <div class="message">
            <asp:Label ID="lblMessage" runat="server" Text=""></asp:Label>
        </div>
    
</asp:Content>
