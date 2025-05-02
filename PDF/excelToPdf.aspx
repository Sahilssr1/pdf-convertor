<%@ Page Title="" Language="C#" MasterPageFile="~/PDF/PDF.Master" AutoEventWireup="true" CodeBehind="excelToPdf.aspx.cs" Inherits="PDFconvertor.PDF.excelToPdf" %>

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

        <h2>Convert Excel to PDF</h2>
        
            <asp:FileUpload ID="fileUpload" runat="server" CssClass="upload-box"/>
            <br><br>
            <asp:Button ID="btnConvert" runat="server" Text="Convert to PDF" CssClass="convert-btn" OnClick="btnConvert_Click" />
            <br><br>
            <asp:Label ID="lblMessage" runat="server" CssClass="message-label" Text=""></asp:Label>
        
    
</asp:Content>
