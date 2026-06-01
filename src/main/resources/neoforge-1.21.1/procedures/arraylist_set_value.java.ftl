<#include "mcitems.ftl">

<#if field$output_type == "MCItem">
    <#assign method = "${input$var}.set(${opt.toInt(input$index)}, ${mappedMCItemToItemStackCode(input$value)});">
<#elseif field$output_type == "MCItemBlock">
    <#assign method = "${input$var}.set(${opt.toInt(input$index)}, ${mappedBlockToBlockStateCode(input$value)});">
<#else>
    <#assign method = "${input$var}.set(${opt.toInt(input$index)}, ${input$value});">
</#if>

<#if input$var?contains("${JavaModName}Variables.WorldVariables")>
    ${method}
    ${JavaModName}Variables.WorldVariables.get(world).markSyncDirty();
<#elseif input$var?contains("${JavaModName}Variables.MapVariables")>
    ${method}
    ${JavaModName}Variables.MapVariables.get(world).markSyncDirty();
<#else>
    ${method}
</#if>