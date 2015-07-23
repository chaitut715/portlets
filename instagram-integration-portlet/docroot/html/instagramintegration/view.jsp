
<%@page import="com.liferay.portal.kernel.util.Validator"%>
<%@page import="com.smartechz.tools.mygeoloc.Geobytes"%>
<%@page import="com.sola.instagram.util.PaginatedCollection"%>
<%@page import="com.sola.instagram.model.Media.Image"%>
<%@page import="com.sola.instagram.model.Media"%>
<%@page import="java.util.List"%>
<%@page import="com.sola.instagram.InstagramSession"%>
<%@page import="com.sola.instagram.auth.AccessToken"%>
<%@page import="com.liferay.portal.util.PortalUtil"%>
<%@page import="com.sola.instagram.auth.InstagramAuthentication"%>
<%@ include file="/html/instagramintegration/init.jsp" %>


<%
String portletId = (String)renderRequest.getAttribute(
		WebKeys.PORTLET_ID);

if(portletId==null){
	portletId = ParamUtil.getString(renderRequest, "portletResource");
}
Portlet portlet = PortletLocalServiceUtil.getPortletById(portletId);
FriendlyURLMapper friendlyURLMapper = portlet.getFriendlyURLMapperInstance();
String redirectURL = PortalUtil.getLayoutFriendlyURL(layout, themeDisplay);
if(friendlyURLMapper!=null){
	redirectURL = redirectURL+"/-/"+friendlyURLMapper.getMapping();
}


%>
<%

String accessTokenString = portletPreferences.getValue("accessTokenString", null);
InstagramAuthentication auth = new InstagramAuthentication();
auth.setRedirectUri(redirectURL)
.setClientSecret(clientSecret)
.setClientId(clientId)
;
%>

<c:choose>
	<c:when test="<%=clientId ==null || clientSecret ==null  %>">
		<h2>You are two steps away from accessing Instagram feed around you</h2>
		<div class="portlet-msg-info">
			<ol>
				<li>Configure client id and secret of Instagram client</li>
				<li>Login with Instagram Account</li>
			</ol>
		
		</div>
	</c:when>
	<c:when test="<%=accessTokenString==null %>">
		<h2>You are one step away from accessing Instagram feed around you</h2>
		
		<%
			String authUrl = auth.getAuthorizationUri();
		%>
		<aui:a href="<%=authUrl%>"><aui:button value="Login with Instagram Account" type="submit"></aui:button></aui:a>
		
	</c:when>
	<c:otherwise>
		<%
		auth.buildFromAccessToken(accessTokenString);
		InstagramSession instaSession = new InstagramSession(auth.getAccessToken());
		List<Media> feed= instaSession.searchMedia(Geobytes.get("Latitude"), Geobytes.get("Longitude"), null, null, 5000);
		/* PaginatedCollection<Media> feed = instaSession.getRecentPublishedMedia(auth.getAuthenticatedUser().getId());  */
		%>
		<div id="myGallery">
		
		<%
		for(Media media: feed) {
			  Image fullImage = media.getStandardResolutionImage();
			  Image thumbnailImage= media.getThumbnailImage();
			  //System.out.println("userid:"+media.getUser().getId()+"   username:"+media.getUser().getUserName()+"Full Name:"+media.getUser().getFullName());
			  String profileLinkName = Validator.isNotNull(media.getUser().getFullName())?media.getUser().getFullName():media.getUser().getUserName();
			  String userProfileURL = "&lt;a href=\"http:&#47;&#47;instagram.com&#47;"+media.getUser().getUserName()+"\"&gt;"+profileLinkName+"&lt;&#47;a&gt;&nbsp;&nbsp;";
				  %>	  
			
			
			 <a href="<%=fullImage.getUri() %>" title='<%=media.getCaption()!=null?userProfileURL+media.getCaption().getText():userProfileURL%>'>
   				 <img class="picture" src="<%=thumbnailImage.getUri() %>" />
  			</a>

			
		<%  
		}
		%>
		</div>
	</c:otherwise>
</c:choose>
<script type="text/javascript">
YUI().use(
		  'aui-image-viewer-gallery',
		  function(Y) {
		    new Y.ImageGallery(
		      {
		        caption: 'Feed around you',
		        delay: 2000,
		        links: '#myGallery a',
		        pagination: {
		          total: 5
		        }
		      }
		    ).render();
		  }
		);
</script>