namespace MDTLTIPSSampleAction
{
    partial class MDTLTIPSSampleControl
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Component Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify 
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.label1 = new System.Windows.Forms.Label();
            this.PackageName = new System.Windows.Forms.TextBox();
            this.SuspendLayout();
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(14, 164);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(125, 13);
            this.label1.TabIndex = 47;
            this.label1.Text = "PowerShellGet package:";
            // 
            // PackageName
            // 
            this.PackageName.BackColor = System.Drawing.SystemColors.ButtonHighlight;
            this.PackageName.Location = new System.Drawing.Point(14, 180);
            this.PackageName.Name = "PackageName";
            this.PackageName.Size = new System.Drawing.Size(359, 20);
            this.PackageName.TabIndex = 48;
            // 
            // MDTLTIPSSampleControl
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.Controls.Add(this.PackageName);
            this.Controls.Add(this.label1);
            this.Name = "MDTLTIPSSampleControl";
            this.Controls.SetChildIndex(this.txtParentActionType, 0);
            this.Controls.SetChildIndex(this.txtParentActionDescription, 0);
            this.Controls.SetChildIndex(this.txtParentActionName, 0);
            this.Controls.SetChildIndex(this.label1, 0);
            this.Controls.SetChildIndex(this.PackageName, 0);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.TextBox PackageName;
    }
}
