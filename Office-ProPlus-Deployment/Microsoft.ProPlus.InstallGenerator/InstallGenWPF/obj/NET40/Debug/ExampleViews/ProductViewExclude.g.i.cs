﻿#pragma checksum "..\..\..\..\ExampleViews\ProductViewExclude.xaml" "{406ea660-64cf-4c82-b6f0-42d48172a799}" "3C6D8B30323A7D86FF3B90C4C7D70A4E"
//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:4.0.30319.34209
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

using MahApps.Metro.Controls;
using MetroDemo;
using MetroDemo.ExampleViews;
using System;
using System.Diagnostics;
using System.Windows;
using System.Windows.Automation;
using System.Windows.Controls;
using System.Windows.Controls.Primitives;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Forms.Integration;
using System.Windows.Ink;
using System.Windows.Input;
using System.Windows.Markup;
using System.Windows.Media;
using System.Windows.Media.Animation;
using System.Windows.Media.Effects;
using System.Windows.Media.Imaging;
using System.Windows.Media.Media3D;
using System.Windows.Media.TextFormatting;
using System.Windows.Navigation;
using System.Windows.Shapes;
using System.Windows.Shell;


namespace MetroDemo.ExampleViews {
    
    
    /// <summary>
    /// ProductViewExclude
    /// </summary>
    public partial class ProductViewExclude : System.Windows.Controls.UserControl, System.Windows.Markup.IComponentConnector {
        
        
        #line 37 "..\..\..\..\ExampleViews\ProductViewExclude.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.DataGrid AzureDataGrid;
        
        #line default
        #line hidden
        
        
        #line 74 "..\..\..\..\ExampleViews\ProductViewExclude.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.DataGrid AzureDataGrid2;
        
        #line default
        #line hidden
        
        private bool _contentLoaded;
        
        /// <summary>
        /// InitializeComponent
        /// </summary>
        [System.Diagnostics.DebuggerNonUserCodeAttribute()]
        [System.CodeDom.Compiler.GeneratedCodeAttribute("PresentationBuildTasks", "4.0.0.0")]
        public void InitializeComponent() {
            if (_contentLoaded) {
                return;
            }
            _contentLoaded = true;
            System.Uri resourceLocater = new System.Uri("/MetroDemo;component/exampleviews/productviewexclude.xaml", System.UriKind.Relative);
            
            #line 1 "..\..\..\..\ExampleViews\ProductViewExclude.xaml"
            System.Windows.Application.LoadComponent(this, resourceLocater);
            
            #line default
            #line hidden
        }
        
        [System.Diagnostics.DebuggerNonUserCodeAttribute()]
        [System.CodeDom.Compiler.GeneratedCodeAttribute("PresentationBuildTasks", "4.0.0.0")]
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Never)]
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Design", "CA1033:InterfaceMethodsShouldBeCallableByChildTypes")]
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Maintainability", "CA1502:AvoidExcessiveComplexity")]
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1800:DoNotCastUnnecessarily")]
        void System.Windows.Markup.IComponentConnector.Connect(int connectionId, object target) {
            switch (connectionId)
            {
            case 1:
            
            #line 13 "..\..\..\..\ExampleViews\ProductViewExclude.xaml"
            ((MetroDemo.ExampleViews.ProductViewExclude)(target)).Loaded += new System.Windows.RoutedEventHandler(this.ProductViewExclude_OnLoaded);
            
            #line default
            #line hidden
            return;
            case 2:
            this.AzureDataGrid = ((System.Windows.Controls.DataGrid)(target));
            
            #line 44 "..\..\..\..\ExampleViews\ProductViewExclude.xaml"
            this.AzureDataGrid.DataContextChanged += new System.Windows.DependencyPropertyChangedEventHandler(this.AzureDataGrid_OnDataContextChanged);
            
            #line default
            #line hidden
            return;
            case 3:
            this.AzureDataGrid2 = ((System.Windows.Controls.DataGrid)(target));
            
            #line 81 "..\..\..\..\ExampleViews\ProductViewExclude.xaml"
            this.AzureDataGrid2.DataContextChanged += new System.Windows.DependencyPropertyChangedEventHandler(this.AzureDataGrid_OnDataContextChanged);
            
            #line default
            #line hidden
            return;
            }
            this._contentLoaded = true;
        }
    }
}
