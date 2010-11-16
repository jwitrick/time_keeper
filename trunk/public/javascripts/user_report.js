function makeDivVisible(div_name){
                $("div#"+div_name).removeAttr('style');
        }
function makeDivHidden(div_name){
                $("div#"+div_name).attr('style', 'display:none');
        }
function addDataToSelect(data, select_element, sel_value){
                $.each(data, function(d, t){
                        if (sel_value == t) {
                          row = "<option value=\"" + t + "\" SELECTED>" + t + "</option>";
                        }               
                        else{
                          row = "<option value=\"" + t + "\">" + t + "</option>";
                        }
                          $(row).appendTo("select#"+select_element);
                });
        }
function setDateOptions(data){
                $.each(data.entries, function(d, t){
                        $.each(t, function(i, j){
                                alert(j.name);
                        });
                });
                $("select#report_date_type option").remove();
                var date_type = data.dateoptions;
                addDataToSelect(date_type, "report_date_type", data.dateoptions_sel);
                $("select#report_date_range option").remove();
                var date_range = data.daterange;
                addDataToSelect(date_range, "report_date_range", data.daterange_sel);
                $("select#report_date_subtype option").remove();
                var date_suboptions = data.datesuboptions;
                addDataToSelect(date_suboptions, "report_date_subtype", data.datesubtype_sel);
                makeDivHidden("user_report_project_selectors");
                makeDivVisible("user_report_date_selectors");
                makeDivHidden("user_report_chartered_selectors");
        }
function setProjectOptions(data){
                $("select#report_projects_list option").remove();
                var projects_list = data.projects;
                $.each(projects_list, function(i, j){
                        $.each(j, function(d, t){
                          if (data.project == t.id){
                            row = "<option value=\"" + t.id + "\" SELECTED>" + t.name + "</option>";
                          }else{
                            row = "<option value=\"" + t.id + "\">" + t.name + "</option>";
                          }
                          $(row).appendTo("select#report_projects_list");
                        });
                });
                row = "<option value=\"All\">All</option>";
                $(row).appendTo("select#report_projects_list");                                       
                $("select#report_project_options option").remove();
                var project_options = data.project_options; 
                addDataToSelect(project_options, "report_project_options", data.project_opt);
                makeDivVisible("user_report_project_selectors");
                makeDivHidden("user_report_date_selectors");
                makeDivHidden("user_report_chartered_selectors");
        }
function setCharteredOptions(data){
                $("select#report_chartered_range option").remove();
                var range = data.range;
                addDataToSelect(range, "report_chartered_range", data.range_sel);
                makeDivVisible("user_report_chartered_selectors");
                makeDivHidden("user_report_date_selectors");
                makeDivHidden("user_report_project_selectors");
        }
function setNonCharteredOptions(data){
                $("select#report_chartered_range option").remove();
                var range = data.range;
                addDataToSelect(range, "report_chartered_range", data.range_sel);
                makeDivVisible("user_report_chartered_selectors");
                makeDivHidden("user_report_date_selectors");
                makeDivHidden("user_report_project_selectors");
        }
function loadSelectorData(report_value, report_string){
	var id_value_string = report_value;
        $.ajax({
          dataType: "json",
          cache: false,
          url: '/entry/user_report_suboptions/',
          data: "id=" + id_value_string + report_string,
          timeout: 2000,
          success: function(data){
            if(id_value_string == 'Date'){
              setDateOptions(data);
            }
            if(id_value_string == 'Project'){
              setProjectOptions(data);
            }
            if(id_value_string == 'Chartered'){
              setCharteredOptions(data);
            }
            if(id_value_string == 'NonChartered'){
              setNonCharteredOptions(data);
            }
          } //end success
        }); //end ajax                  
      }
function loadInitialOptions(value){
	loadSelectorData(value, "&change=date_type");
      }
