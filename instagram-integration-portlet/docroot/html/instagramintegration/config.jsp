<%@page import="com.liferay.portal.kernel.util.PropsKeys"%>
<%@page import="com.liferay.portal.kernel.util.PropsUtil"%>
<%@page import="com.liferay.portal.model.Group"%>
<%@page import="com.liferay.portal.kernel.language.LanguageUtil"%>
<%@ include file="/html/instagramintegration/init.jsp" %>

<liferay-portlet:actionURL portletConfiguration="true" var="configurationURL" />
<%

String portletId = ParamUtil.getString(renderRequest, "portletResource");

Portlet portlet = PortletLocalServiceUtil.getPortletById(portletId);
String redirectURL = getServletURL(portlet, themeDisplay);
String websiteURL = themeDisplay.getPortalURL();

%>

This is the <b>Instagram Integration</b> portlet in Config mode.
<aui:form action="<%= configurationURL %>" method="post" name="fm">
    <aui:input name="<%= Constants.CMD %>" type="hidden" value="<%= Constants.UPDATE %>" />
    <aui:input label="CLIENT ID" name="clientId" type="text" value="<%= clientId %>" required="true"/>
	<aui:input label="CLIENT SECRET" name="clientSecret" type="text" value="<%= clientSecret %>" required="true"/>
	<aui:field-wrapper label="WEBSITE URL">
		<liferay-ui:input-resource url="<%= websiteURL %>" />
	</aui:field-wrapper>
	<aui:field-wrapper label="Redirect URI">
		<liferay-ui:input-resource url="<%= redirectURL %>" />
	</aui:field-wrapper>
	
    <aui:button-row>
       <aui:button type="submit" />
    </aui:button-row>
</aui:form>

<%!
public String getServletURL(
		Portlet portlet, ThemeDisplay themeDisplay)
	throws PortalException, SystemException {

	Layout layout = themeDisplay.getLayout();

	StringBundler sb = new StringBundler();

	sb.append(themeDisplay.getPortalURL());

	if (themeDisplay.isI18n()) {
		sb.append(themeDisplay.getI18nPath());
	}


	Group group = layout.getGroup();

	if (layout.isPrivateLayout()) {
		if (group.isUser()) {
			sb.append(PropsUtil.get(PropsKeys.LAYOUT_FRIENDLY_URL_PRIVATE_USER_SERVLET_MAPPING));
		}
		else {
			sb.append(PropsUtil.get(PropsKeys.LAYOUT_FRIENDLY_URL_PRIVATE_GROUP_SERVLET_MAPPING));
		}
	}
	else {
		sb.append(PropsUtil.get(PropsKeys.LAYOUT_FRIENDLY_URL_PUBLIC_SERVLET_MAPPING));
	}

	sb.append(group.getFriendlyURL());
	sb.append(layout.getFriendlyURL(themeDisplay.getLocale()));

	sb.append("/-/");

	FriendlyURLMapper friendlyURLMapper =
		portlet.getFriendlyURLMapperInstance();

	if ((friendlyURLMapper != null) && !portlet.isInstanceable()) {
		sb.append(friendlyURLMapper.getMapping());
	}
	else {
		sb.append(portlet.getPortletId());
	}

	return sb.toString();
}

%>