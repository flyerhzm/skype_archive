# encoding: utf-8
module Support
  module SqliteSeed
    def seed_db
      richard = DB[:contacts].insert(:skypename => "gii.richard.huang", :displayname => "Richard Huang")
      flyerhzm = DB[:contacts].insert(:skypename => "flyerhzm", :displayname => "Richard Huang")
      jason = DB[:contacts].insert(:skypename => "gii.jason.lai", :displayname => "Jason Lai")

      gree_conversation_id = DB[:conversations].insert(:identity => "$gii.jason.lai/123456789", :displayname => "GREE")
      myself_conversation_id = DB[:conversations].insert(:identity => "flyerhzm", :displayname => "flyerhzm")

      DB[:participants].insert(:convo_id => gree_conversation_id, :identity => "gii.jason.lai")
      DB[:participants].insert(:convo_id => gree_conversation_id, :identity => "gii.richard.huang")
      DB[:participants].insert(:convo_id => myself_conversation_id, :identity => "flyerhzm")
      DB[:participants].insert(:convo_id => myself_conversation_id, :identity => "gii.richard.huang")

      DB[:messages].insert(:convo_id => gree_conversation_id, :author => "gii.jason.lai", :from_dispname => "Jason Lai",
                           :remote_id => 1, :body_xml => "gree message 1", :type => 61, :timestamp => Time.now.to_i - 3600)
      DB[:messages].insert(:convo_id => gree_conversation_id, :author => "gii.richard.huang", :from_dispname => "Richard Huang",
                           :remote_id => 1, :body_xml => "gree message 2", :type => 61, :timestamp => Time.now.to_i - 1800)
      DB[:messages].insert(:convo_id => gree_conversation_id, :author => "gii.jason.lai", :from_dispname => "Jason Lai / (赖)",
                           :remote_id => 1, :body_xml => "gree message 3", :type => 61, :timestamp => Time.now.to_i)
      DB[:messages].insert(:convo_id => myself_conversation_id, :author => "gii.richard.huang", :from_dispname => "Richard Huang",
                           :remote_id => 1, :body_xml => "self message 11", :type => 61, :timestamp => Time.now.to_i)
      DB[:messages].insert(:convo_id => myself_conversation_id, :author => "flyerhzm", :from_dispname => "Richard Huang",
                           :remote_id => 1, :body_xml => "
<partlist alt=\"\">
  <part identity=\"flyerhzm\">
    <name>Ron Buell</name>
    <duration>1099</duration>
  </part>
  <part identity=\"gii.richard.huang\">
    <name>Richard Huang</name>
    <duration>1099</duration>
  </part>
</partlist>", :type => 39, :timestamp => Time.now.to_i)
    end

    def setup_db
      DB.create_table :contacts do
        primary_key :id
        String :skypename
        String :displayname
      end

      DB.create_table :conversations do
        primary_key :id
        String :identity
        String :displayname
      end

      DB.create_table :participants do
        primary_key :id
        Integer :convo_id
        String :identity
      end

      DB.create_table :messages  do
        primary_key :id
        Integer :convo_id
        String :author
        String :from_dispname
        Integer :remote_id
        String :body_xml
        Integer :type
        Integer :timestamp
      end
    end

    def teardown_db
      DB.tables.each do |table|
        DB.drop_table(table)
      end
    end

    extend self
  end
end
