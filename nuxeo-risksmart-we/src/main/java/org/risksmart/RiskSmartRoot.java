/*
 * (C) Copyright 2015 Nuxeo SA (http://nuxeo.com/) and contributors.
 *
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the GNU Lesser General Public License
 * (LGPL) version 2.1 which accompanies this distribution, and is available at
 * http://www.gnu.org/licenses/lgpl-2.1.html
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 *
 * Contributors:
 *     Thibaud Arguillere
 */

package org.risksmart;

import javax.security.auth.login.LoginException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.nuxeo.ecm.core.api.CoreSession;
import org.nuxeo.ecm.core.api.DocumentModel;
import org.nuxeo.ecm.core.api.DocumentModelList;
import org.nuxeo.ecm.core.api.NuxeoPrincipal;
import org.nuxeo.ecm.core.rest.DocumentFactory;
import org.nuxeo.ecm.platform.ui.web.auth.service.PluggableAuthenticationService;
import org.nuxeo.ecm.platform.usermanager.UserManager;
import org.nuxeo.ecm.webengine.model.WebObject;
import org.nuxeo.ecm.webengine.model.impl.ModuleRoot;
import org.nuxeo.runtime.api.Framework;

import static org.nuxeo.ecm.platform.ui.web.auth.NXAuthConstants.REQUESTED_URL;

/**
 * The root entry for the WebEngine module.
 * 
 * Everything is handled from here in this single "/risksmart" path.
 * 
 * Basically, the code detects what form (here we are in WebEngine, so it means
 * what template) must be sent to the browser. This depends on:
 * <p>
 * -> Current user: customer, broker, insurer
 * <p>
 * -> State of the CyberRisk application and its workflow.
 * <p>
 * So, for example:
 * <p>
 * * customer + no application => create a new one
 * <p>
 * * Customer and one applicaiton => check status
 * <p>
 * * Broker and a workflow node for me => handle it
 * <p>
 * * Broker and a no workflow node for me => get status
 * <p>
 * * etc.
 * <p>
 * ==========================================================================
 * VERY IMPORTANT ABOUT THIS POC
 * ========================================================================== We
 * handle a _SINGLE_ application for a _SINGLE_ customer: Just one, not a list
 * of applications
 * 
 * 
 * ==========================================================================
 * VMOVE EVERYTHING TO JavaScript
 * ==========================================================================
 * People can easily read this code and reproduce the behavior with
 * JavaScript/nuxeo.js. I recommend that, if this is what you want to do, you
 * create an operation (java) that does this dispatch and returns a value the
 * caller can use to display the correct form in the browser. Here,
 * "the correct form" means that in the context of a Single Page Application,
 * you would show/hide/create/remove/etc. the elements dynamically depending on
 * the result of the call.
 * 
 * Check the corresponding Studio project for the Workflow, the documents, the
 * lifecycle, the groups, ...
 * 
 */
@Path("/risksmart")
@Produces("text/html;charset=UTF-8")
@WebObject(type = "RiskSmartRoot")
public class RiskSmartRoot extends ModuleRoot {

    private static Log log = LogFactory.getLog(RiskSmartRoot.class);

    // EXPECTED LIFE CYCLE STATES (check with Studio project)
    public static final String STATE_PROJECT = "project";

    public static final String STATE_BROKER = "broker_review";

    public static final String STATE_INSURER = "insurer_review";

    @GET
    public Object doGet() throws LoginException {

        // Get the user
        NuxeoPrincipal nxPcipal = (NuxeoPrincipal) ctx.getPrincipal();
        boolean isCustomer = nxPcipal.isMemberOf("Customers");
        boolean isBroker = nxPcipal.isMemberOf("Brokers");
        boolean isInsurer = nxPcipal.isMemberOf("Insurers");

        String userName = nxPcipal.getName();
        ctx.setProperty("currentUser", userName);
        ctx.setProperty(
                "firstLastName",
                calculateFirstLastName(nxPcipal.getFirstName(),
                        nxPcipal.getLastName(), userName));

        // Other values
        ctx.setProperty("workflowIsRunning", false);
        ctx.setProperty("applicationStatus", "");
        ctx.setProperty("applicationStatusDetails", "");
        ctx.setProperty("applicantFirstLastName", "");
        ctx.setProperty("prevInsurance", "");

        // get the applicant_data doc
        DocumentModel theDoc = getRunningApplicationDocument(nxPcipal);
        // In our model, an application is always bound to a workflow when
        // getRunningApplicationDocument() returned a document
        ctx.setProperty("workflowIsRunning", true);

        // So.
        // -> If we have no running task => start the
        // "New RiskSmart Application" process
        // -> Else, it depends on the current user:
        // - A customer => check status of the application
        // - A broker or an insurer => resolve the task
        Object toBeReturned = null;
        if (theDoc == null) {
            toBeReturned = getView("startNewApplication");
        } else {
            // Get details about the applicant for display (possibly)
            if (!isCustomer) {
                ctx.setProperty(
                        "applicantFirstLastName",
                        calculateFirstLastName(
                                (String) theDoc.getPropertyValue("cra:first_name"),
                                (String) theDoc.getPropertyValue("cra:last_name"),
                                (String) theDoc.getPropertyValue("cra:user")));
            }

            // In the Studio project, the workflow and the lifecycle state are
            // closely tied => we know there is a node to be handled
            String lcs = theDoc.getCurrentLifeCycleState();
            String status = "", statusDetails = "";
            String viewToreturn = "";
            if (isCustomer) {
                if (lcs.equals(STATE_PROJECT)) {
                    viewToreturn = "index";
                } else {
                    status = "Your Cyber Risk Application ("
                            + theDoc.getTitle() + ") is under review.";
                    statusDetails = "You will receive an email letting you know the state of your application and if further actions are requested.";
                    viewToreturn = "checkStatus";
                }

            } else if (isBroker) {
                if (lcs.equals(STATE_BROKER)) {
                    viewToreturn = "index";
                } else {
                    status = "The Cyber Risk Application (" + theDoc.getTitle()
                            + ") is under review (state: " + lcs + ")";
                    if (lcs.equals(STATE_PROJECT)) {
                        statusDetails = "The customer is filling the missing information";
                    } else if (lcs.equals(STATE_INSURER)) {
                        statusDetails = "The insurer is reviewing the application";
                    }
                    viewToreturn = "checkStatus";
                }
            } else if (isInsurer) {
                if (lcs.equals(STATE_INSURER)) {
                    viewToreturn = "index";
                } else {
                    status = "The Cyber Risk Application (" + theDoc.getTitle()
                            + ") is under review (state: " + lcs + ")";
                    if (lcs.equals(STATE_PROJECT)) {
                        statusDetails = "The customer is filling the missing information";
                    } else if (lcs.equals(STATE_BROKER)) {
                        statusDetails = "The broker is reviewing the application";
                    }
                    viewToreturn = "checkStatus";
                }
            } else {
                status = "The current Cyber Risk Application is"
                        + theDoc.getTitle();
                viewToreturn = "checkStatus";
            }

            ctx.setProperty("applicationStatus", status);
            ctx.setProperty("applicationStatusDetails", statusDetails);
            toBeReturned = getView(viewToreturn).arg("Document",
                    DocumentFactory.newDocument(ctx, theDoc));

            String prevInsurance = (String) theDoc.getPropertyValue("cra:previous_insurance");
            if (prevInsurance == null || prevInsurance.isEmpty()) {
                prevInsurance = "(none)";
            }
            ctx.setProperty("prevInsurance", prevInsurance);
            ;

        }
        if (toBeReturned == null) {
            // return a generic page for debug in the POC
        }

        return toBeReturned;

    }

    protected DocumentModel getRunningApplicationDocument(
            NuxeoPrincipal inNxPcipal) {

        DocumentModel theDoc = null;
        CoreSession session = ctx.getCoreSession();

        DocumentModelList docs = null;
        if (inNxPcipal.isMemberOf("Customers")) {
            // Find any application by this user which is "running"
            docs = session.query("SELECT * FROM CyberRiskApp WHERE cra:user ='"
                    + inNxPcipal.getName()
                    + "' AND ecm:currentLifeCycleState IN ('project', 'broker_review', 'insurer_review', 'offer')");
        } else {
            // Find any application, we'll pick-up the first one for the POC
            docs = session.query("SELECT * FROM CyberRiskApp WHERE"
                    + " ecm:currentLifeCycleState IN ('project', 'broker_review', 'insurer_review', 'offer')");
        }
        if (docs != null && docs.size() > 0) {
            theDoc = docs.get(0);
        }
        return theDoc;
    }

    protected String calculateFirstLastName(String inFirst, String inLast,
            String inUserName) {

        String firstLastName = "";
        if (inFirst != null && !inFirst.isEmpty()) {
            firstLastName = inFirst;
        }
        if (inLast != null && !inLast.isEmpty()) {
            if (!firstLastName.isEmpty()) {
                firstLastName += " ";
            }
            firstLastName += inLast;
        }

        return firstLastName.isEmpty() ? inUserName : firstLastName;
    }

    @GET
    @Path("logout")
    public Object doLogout(@Context HttpServletResponse response)
            throws Exception {

        Cookie cookie = new Cookie("JSESSIONID", null);
        cookie.setMaxAge(0);
        cookie.setPath("/");

        response.addCookie(cookie);

        PluggableAuthenticationService service = (PluggableAuthenticationService) Framework.getRuntime().getComponent(
                PluggableAuthenticationService.NAME);
        service.invalidateSession(request);

        /*
         * String redirect = request.getParameter(REQUESTED_URL); if (redirect
         * != null) { log.debug("Logout done: Redirect to default URL: " +
         * redirect); } else { redirect = getContext().getBasePath(); } return
         * redirect(redirect);
         */
        return redirect("/nuxeo/site/risksmart");
    }

}
