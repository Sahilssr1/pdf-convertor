<%@ Page Title="" Language="C#" MasterPageFile="~/PDF/PDF.Master" AutoEventWireup="true" CodeBehind="unlockPdf.aspx.cs" Inherits="PDFconvertor.PDF.unlockPdf" %>
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
    <div>
            <h2>Unlock PDF</h2>
            
            <asp:fileUpload ID="fileUpload" runat="server" />
            <br /><br />
            
            <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" placeholder="Enter PDF Password"></asp:TextBox>
            <br /><br />
            
            <asp:Button ID="btnUnlock" runat="server" Text="Unlock PDF" OnClick="btnUnlock_Click" />
            <br /><br />
            
            <asp:Label ID="lblMessage" runat="server" ForeColor="Red"></asp:Label>
        </div>
</asp:Content>
