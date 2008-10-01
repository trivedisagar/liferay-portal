<%
/**
 * Copyright (c) 2000-2008 Liferay, Inc. All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
%>

<%@ include file="/html/portlet/enterprise_admin/init.jsp" %>

<%
String tabs2 = ParamUtil.getString(request, "tabs2", "current");

String cur = ParamUtil.getString(request, "cur");

String redirect = ParamUtil.getString(request, "redirect");

UserGroup userGroup = (UserGroup)request.getAttribute(WebKeys.USER_GROUP);

PortletURL portletURL = renderResponse.createRenderURL();

portletURL.setWindowState(WindowState.MAXIMIZED);

portletURL.setParameter("struts_action", "/enterprise_admin/edit_user_group_assignments");
portletURL.setParameter("tabs1", tabs1);
portletURL.setParameter("tabs2", tabs2);
portletURL.setParameter("redirect", redirect);
portletURL.setParameter("userGroupId", String.valueOf(userGroup.getUserGroupId()));
%>

<script type="text/javascript">
	function <portlet:namespace />updateUserGroupUsers(assignmentsRedirect) {
		document.<portlet:namespace />fm.<portlet:namespace /><%= Constants.CMD %>.value = "user_group_users";
		document.<portlet:namespace />fm.<portlet:namespace />assignmentsRedirect.value = assignmentsRedirect;
		document.<portlet:namespace />fm.<portlet:namespace />addUserIds.value = Liferay.Util.listCheckedExcept(document.<portlet:namespace />fm, "<portlet:namespace />allRowIds");
		document.<portlet:namespace />fm.<portlet:namespace />removeUserIds.value = Liferay.Util.listUncheckedExcept(document.<portlet:namespace />fm, "<portlet:namespace />allRowIds");
		submitForm(document.<portlet:namespace />fm);
	}
</script>

<form action="<portlet:actionURL windowState="<%= WindowState.MAXIMIZED.toString() %>"><portlet:param name="struts_action" value="/enterprise_admin/edit_user_group_assignments" /></portlet:actionURL>" method="post" name="<portlet:namespace />fm">
<input name="<portlet:namespace /><%= Constants.CMD %>" type="hidden" value="" />
<input name="<portlet:namespace />tabs1" type="hidden" value="<%= HtmlUtil.escape(tabs1) %>" />
<input name="<portlet:namespace />tabs2" type="hidden" value="<%= HtmlUtil.escape(tabs2) %>" />
<input name="<portlet:namespace />assignmentsRedirect" type="hidden" value="" />
<input name="<portlet:namespace />userGroupId" type="hidden" value="<%= userGroup.getUserGroupId() %>" />

<liferay-ui:message key="edit-assignments-for-user-group" />: <%= userGroup.getName() %>

<br /><br />

<liferay-ui:tabs
	names="current,available"
	param="tabs2"
	url="<%= portletURL.toString() %>"
	backURL="<%= redirect %>"
/>

<input name="<portlet:namespace />addUserIds" type="hidden" value="" />
<input name="<portlet:namespace />removeUserIds" type="hidden" value="" />

<liferay-ui:search-container
	searchContainer="<%= new UserSearch(renderRequest, portletURL) %>"
	rowChecker="<%= new UserUserGroupChecker(renderResponse, userGroup) %>"
>
	<liferay-ui:search-form
		page="/html/portlet/enterprise_admin/user_search.jsp"
	/>

	<%
	UserSearchTerms searchTerms = (UserSearchTerms)searchContainer.getSearchTerms();

	LinkedHashMap userParams = new LinkedHashMap();

	if (filterManageableOrganizations) {
		List manageableOrganizations = OrganizationLocalServiceUtil.getManageableOrganizations(user.getUserId());

		Long[] manageableOrganizationIds = EnterpriseAdminUtil.getOrganizationIds(manageableOrganizations);

		userParams.put("usersOrgs", manageableOrganizationIds);
	}

	if (tabs2.equals("current")) {
		userParams.put("usersUserGroups", new Long(userGroup.getUserGroupId()));
	}
	%>

	<%@ include file="/html/portlet/enterprise_admin/user_search_results.jspf" %>

	<liferay-ui:search-container-results
		results="<%= results1 %>"
		total="<%= total1 %>"
	/>

	<liferay-ui:search-container-row
		className="com.liferay.portal.model.User"
		keyProperty="userId"
		modelVar="user2"
	>
		<liferay-ui:search-container-column-text
			name="name"
			property="fullName"
		/>

		<liferay-ui:search-container-column-text
			name="screen-name"
			property="screenName"
		/>
	</liferay-ui:search-container-row>

	<div class="separator"><!-- --></div>

	<input type="button" value="<liferay-ui:message key="update-associations" />" onClick="<portlet:namespace />updateUserGroupUsers('<%= portletURL.toString() %>&<portlet:namespace />cur=<%= cur %>');" />

	<br /><br />

	<liferay-ui:search-iterator />

</liferay-ui:search-container>

</form>