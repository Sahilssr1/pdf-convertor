<%@ Page Title="" Language="C#" MasterPageFile="~/PDF/PDF.Master" AutoEventWireup="true" CodeBehind="protectPdf.aspx.cs" Inherits="PDFconvertor.PDF.protectPdf" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
      <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    
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
     
        <h2 class="text-center mb-4">🔒 Protect Your PDF</h2>

      
            <div class="mb-3">
                <label for="fileUpload" class="form-label">📁 Select PDF File:</label>
                <asp:FileUpload ID="fileUpload" runat="server" CssClass="form-control" />
            </div>

            <div class="mb-3">
                <label for="txtPassword" class="form-label">🔑 Enter Password:</label>
                <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Enter password" />
            </div>

            <asp:Button ID="btnProtect" runat="server" Text="🔒 Protect PDF" CssClass="btn btn-primary" OnClick="btnProtect_Click" />

            <div class="message text-center">
                <asp:Label ID="lblMessage" runat="server" CssClass="text-danger"></asp:Label>
            </div>
       
  

    <!-- Bootstrap JS (Optional, for responsive components) -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</asp:Content>
