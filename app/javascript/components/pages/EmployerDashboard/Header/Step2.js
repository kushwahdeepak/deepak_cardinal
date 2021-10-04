import React, {useState} from 'react'
import {Form, Button, Card, Tab, Tabs} from 'react-bootstrap'
import {CustomModalContext} from '../../../../context/CustomModalContext'
import {Step2Context} from '../../../../context/Step2Context'
import './styles/Jobs.scss'

function Step2({job}) {
  const modalBar = React.useContext(CustomModalContext)
  const [key, setKey] = useState('data');
  const [validated, setValidated] = useState(false);
  const handleClick = (event) => {
    const form = event.currentTarget;
    if (form.checkValidity() === false) {
      event.preventDefault();
      event.stopPropagation();
    }
    else{
      modalBar.setBarState({...modalBar, activeCreateForm: 2})
    }
    setValidated(true);
  }
  const handleSkip = () => {
    modalBar.setBarState({...modalBar, activeCreateForm: 2})
  }
  const {
    subject,
    email,
    sms,
    setEmail,
    setSubject,
    setSms
  } = React.useContext(Step2Context)
  
return(
  <Form noValidate validated={validated}>
    <Card>
      <Card.Header>Email Campaign</Card.Header>
      <Card.Body>
        <Card.Title>Subject
        <Form.Control type="text"
            onChange={e => {
              e.target.value.trim() ? setSubject(e.target.value) : setSubject('')
            }}
            value={subject}
            defaultValue={job?.subject ? job.subject : subject}
            required
          />
          <Form.Control.Feedback type="invalid">
            Email campaign is required.
          </Form.Control.Feedback>
        </Card.Title>
        <Tabs activeKey={key} onSelect={(k) => setKey(k)}>
          <Tab eventKey="data" title="First Contact">
            <Form.Control as="textarea" rows={5}
            className="form-control subject-input ml-0"
            onChange={e => {
              e.target.value.trim() ? setEmail(e.target.value) : setEmail('')
            }}
            type="textarea"
            value={email}
            defaultValue={job?.email_desc ? job.email_desc : email}
            required
          />
          <Form.Control.Feedback type="invalid">
            First contact is required.
          </Form.Control.Feedback>
          </Tab>
        </Tabs>
      </Card.Body>
    </Card>
    <Card>
      <Card.Header>Sms campiagn</Card.Header>
      <Card.Body>
        <Tabs activeKey={key} onSelect={(k) => setKey(k)}>
          <Tab eventKey="data" title="First Contact">
            <Form.Control as="textarea" rows={5}
            className="form-control subject-input ml-0"
            type="textarea"
            onChange={e => {
              e.target.value.trim() ? setSms(e.target.value) : setSms('')
            }}
            value={sms}
            defaultValue={job?.sms_desc ? job.sms_desc :sms}
            required
          />
          <Form.Control.Feedback type="invalid">
            Sms campiagn is required
          </Form.Control.Feedback>
          </Tab>
        </Tabs>
      </Card.Body>
    </Card>

  <Button
    variant="primary"
    type="button"
    onClick={handleClick}
    style={{
      margin: 0,
      marginTop: "7px",
    }}
    disabled={!((subject && email && sms) || job)}
  >
    Next
  </Button>
  <Button
    variant="primary"
    type="button"
    onClick={handleSkip}
    style={{
      margin: "0 15px 0 0",
      marginTop: "7px",
    }}
  >
    Skip
  </Button>
</Form>
)
}
export default Step2;