package com.poc;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.PortletConfig;
import javax.portlet.PortletPreferences;

import com.liferay.portal.kernel.portlet.DefaultConfigurationAction;
import com.liferay.portal.kernel.util.ParamUtil;

public class InstagramIntegrationPortletConfiguration extends
		DefaultConfigurationAction {
	@Override
    public void processAction(
        PortletConfig portletConfig, ActionRequest actionRequest,
        ActionResponse actionResponse) throws Exception {

        super.processAction(portletConfig, actionRequest, actionResponse);

        PortletPreferences prefs = actionRequest.getPreferences();
        
        String clientId = ParamUtil.getString(actionRequest, "clientId");
        String clientSecret = ParamUtil.getString(actionRequest, "clientSecret");
        prefs.setValue("clientId", clientId);
        prefs.setValue("clientSecret", clientSecret);
        prefs.store();
        System.out.println("clientId"+clientId);
        System.out.println("clientSecret"+clientSecret);
    }

}
