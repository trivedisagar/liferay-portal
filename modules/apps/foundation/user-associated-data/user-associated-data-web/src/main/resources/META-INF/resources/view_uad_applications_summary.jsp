<%--
/**
 * Copyright (c) 2000-present Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */
--%>

<%@ include file="/init.jsp" %>

<%
ViewUADApplicationsSummaryDisplay viewUADApplicationsSummaryDisplay = (ViewUADApplicationsSummaryDisplay)request.getAttribute(UADWebKeys.VIEW_UAD_APPLICATIONS_SUMMARY_DISPLAY);

int totalCount = viewUADApplicationsSummaryDisplay.getTotalCount();

portletDisplay.setShowBackIcon(true);

PortletURL backURL = renderResponse.createRenderURL();

backURL.setParameter("mvcRenderCommandName", "/view_uad_summary");
backURL.setParameter("p_u_i_d", String.valueOf(selectedUser.getUserId()));

portletDisplay.setURLBack(backURL.toString());

renderResponse.setTitle(StringBundler.concat(selectedUser.getFullName(), " - ", LanguageUtil.get(request, "personal-data-erasure")));
%>

<div class="container-fluid container-fluid-max-xl container-form-lg">
	<div class="sheet sheet-lg">
		<div class="sheet-header">
			<h2 class="sheet-title"><liferay-ui:message key="application-data-review" /></h2>
		</div>

		<div class="sheet-section">
			<h3 class="sheet-subtitle">
				<liferay-ui:message key="status-summary" />
			</h3>

			<div class="autofit-row autofit-row-center">
				<div class="autofit-col autofit-col-expand">
					<div class="autofit-section">
						<strong><liferay-ui:message key="remaining-items" />: </strong><%= totalCount %>
					</div>
				</div>

				<div class="autofit-col">
					<aui:button cssClass="btn-sm" disabled="<%= totalCount > 0 %>" href="<%= backURL.toString() %>" primary="true" value="complete-step" />
				</div>
			</div>
		</div>

		<div class="sheet-section">
			<h3 class="sheet-subtitle"><liferay-ui:message key="applications" /></h3>

			<liferay-ui:search-container
				id="uadApplicationSummaryDisplays"
				searchContainer="<%= viewUADApplicationsSummaryDisplay.getSearchContainer() %>"
			>
				<liferay-ui:search-container-row
					className="com.liferay.user.associated.data.web.internal.display.UADApplicationSummaryDisplay"
					escapedModel="<%= true %>"
					keyProperty="name"
					modelVar="uadApplicationSummaryDisplay"
				>
					<liferay-ui:search-container-column-text
						cssClass="table-cell-expand table-list-title"
						name="name"
						property="name"
					/>

					<liferay-ui:search-container-column-text
						cssClass="table-cell-expand"
						name="items"
						property="count"
					/>

					<liferay-ui:search-container-column-text
						cssClass="table-cell-expand"
						name="status"
					>
						<c:choose>
							<c:when test="<%= uadApplicationSummaryDisplay.getCount() > 0 %>">
								<span class="label label-warning"><liferay-ui:message key="pending" /></span>
							</c:when>
							<c:otherwise>
								<span class="label label-success"><liferay-ui:message key="done" /></span>
							</c:otherwise>
						</c:choose>
					</liferay-ui:search-container-column-text>

					<liferay-ui:search-container-column-jsp
						cssClass="entry-action-column"
						path="/applications_summary_action.jsp"
					/>
				</liferay-ui:search-container-row>

				<liferay-ui:search-iterator
					markupView="lexicon"
				/>
			</liferay-ui:search-container>
		</div>
	</div>
</div>