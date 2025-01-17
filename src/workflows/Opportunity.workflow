<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_Alert_to_user_for_Approval</fullName>
        <description>Email Alert to user for Approval</description>
        <protected>true</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Opportunity_Approval_Mail</template>
    </alerts>
    <alerts>
        <fullName>Email_Alert_to_user_for_Rejected</fullName>
        <description>Email Alert to user for Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Opportunity_Rejection_Mail</template>
    </alerts>
    <fieldUpdates>
        <fullName>Field_Update_to_Approved</fullName>
        <field>Discount_Approved__c</field>
        <literalValue>1</literalValue>
        <name>Field Update to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Field_Update_to_Rejected</fullName>
        <field>Discount_Approved__c</field>
        <literalValue>0</literalValue>
        <name>Field Update to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
</Workflow>
