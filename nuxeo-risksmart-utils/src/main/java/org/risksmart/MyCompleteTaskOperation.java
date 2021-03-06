/*
 * (C) Copyright ${year} Nuxeo SA (http://nuxeo.com/) and contributors.
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
 *     thibaud
 */

package org.risksmart;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.nuxeo.ecm.automation.OperationContext;
import org.nuxeo.ecm.automation.core.Constants;
import org.nuxeo.ecm.automation.core.annotations.Context;
import org.nuxeo.ecm.automation.core.annotations.Operation;
import org.nuxeo.ecm.automation.core.annotations.OperationMethod;
import org.nuxeo.ecm.automation.core.annotations.Param;
import org.nuxeo.ecm.automation.core.collectors.DocumentModelCollector;
import org.nuxeo.ecm.automation.core.util.Properties;
import org.nuxeo.ecm.core.api.ClientException;
import org.nuxeo.ecm.core.api.CoreSession;
import org.nuxeo.ecm.core.api.DocumentModel;
import org.nuxeo.ecm.platform.routing.api.DocumentRoutingService;
import org.nuxeo.ecm.platform.task.Task;

/**
 * Workarund the default COmpleteTaskOperation, native in nuxeo, which has
 * problem with receiving a proprty maps from JSON via a REST call
 */
@Operation(id = MyCompleteTaskOperation.ID, category = Constants.CAT_SERVICES, label = "MyCompleteTaskOperation", description = "Fix the Workflow.CompleteTaskOperation problem when Workflow variables are not strict Strings. 2014-09-18")
public class MyCompleteTaskOperation {

    public static final String ID = "MyCompleteTaskOperation";
    
    private static final Log log = LogFactory.getLog(MyCompleteTaskOperation.class);

    @Context
    protected CoreSession session;

    @Context
    protected OperationContext ctx;

    @Param(name = "status", required = false)
    protected String status;

    @Param(name = "comment", required = false)
    protected String comment;

    @Param(name = "nodeVariables", required = false)
    protected Properties nodeVariables;

    @Param(name = "workflowVariables", required = false)
    protected Properties workflowVariables;

    @Context
    protected DocumentRoutingService documentRoutingService;

    @OperationMethod(collector = DocumentModelCollector.class)
    public DocumentModel completeTask(DocumentModel task)
            throws ClientException, IOException {
        
        log.warn("COUCOU COUCOU COUCOU");;
        System.out.println("POIPOIPOI");
        
        
        Map<String, Object> data = new HashMap<String, Object>();
        if (comment != null) {
            data.put("comment", comment);
        }

        // the service expects an unique map containing both worflow and
        // nodeVariables
        if (nodeVariables != null) {
            data.put(Constants.VAR_WORKFLOW_NODE, nodeVariables);
        }
        if (workflowVariables != null) {
            data.put(Constants.VAR_WORKFLOW, workflowVariables);
        }
        // ================================================ This is the problem
        // data.put(DocumentRoutingConstants._MAP_VAR_FORMAT_JSON,
        // Boolean.TRUE);
        // ====================================================================
        documentRoutingService.endTask(session, task.getAdapter(Task.class),
                data, status);
        return task;
    }

}