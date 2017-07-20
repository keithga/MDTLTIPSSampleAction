using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace MDTLTIPSSampleAction
{

    using Microsoft.BDD.Workbench;
    using System.Reflection;
    using System.IO;

    public partial class MDTLTIPSSampleControl: TaskSequenceActionControl
    {

        #region Constructors

        /// <summary>
        /// This constructor is never used
        /// </summary>
        public MDTLTIPSSampleControl()
            : base()
        {
            InitializeComponent();
        }

        /// <summary>
        /// Initalize the Task Sequence Step within the MDT Console.
        /// Load values into Form.
        /// </summary>
        public MDTLTIPSSampleControl( SmsPageData pageData )
            : base(pageData)
        {
            InitializeComponent();

            txtParentActionType.Text = "PowerShellGallery action";
            this.PackageName.Text = this.PropertyManager["Package"].StringValue;

            // Set up the validators
            this.ControlsValidator.AddControl(PackageName, new ControlDataStateEvaluator(ValidatePackageName), "* Required");
            this.ControlsValidator.ValidateAll();

            Initialized = true;

        }

        #endregion

        #region Validators

        protected ControlDataState ValidatePackageName()
        {
            if (String.IsNullOrEmpty(PackageName.Text.Trim()))
                return ControlDataState.Invalid;
            else
                return ControlDataState.Valid;
        }

        #endregion

        #region ApplyChanges

        static public string GetResourceAsString(string ResourceName)
        {
            using (Stream stream = Assembly.GetExecutingAssembly().GetManifestResourceStream(ResourceName))
            using (StreamReader reader = new StreamReader(stream))
                return reader.ReadToEnd();
        }

        /// <summary>
        /// User has pressed the "Apply" button.
        /// Save data from the on screen forms to the PropertyManager
        /// </summary>
        protected override bool ApplyChanges(out Control errorControl, out bool showError)
        {
            // Check if there are any errors

            if (HasError(out errorControl))
            {
                FixErrors();
                errorControl = null;
                showError = false;
                return false;
            }

            // Save property changes
            this.PropertyManager["Package"].StringValue = this.PackageName.Text;

            return base.ApplyChanges(out errorControl, out showError);
        }
        #endregion ApplyChanges

        #region Event handlers

        #endregion

    }
}

