import React, { useState, useEffect } from 'react'
import {Form, Button, Col} from 'react-bootstrap'
import { Editor } from '@tinymce/tinymce-react';
import Select from 'react-select'
import AsyncSelect from "react-select/async";
import axios from 'axios';

import {colourStyles} from '../Header/styles/Select.styles'
import {CustomModalContext} from '../../../../context/CustomModalContext'
import {Step1Context} from '../../../../context/Step1Context'
import './styles/Jobs.scss'
import styles from './styles/Header.module.scss'
import Util from "../../../../utils/util";

var job_description = '';

const industries = [
{value:"Accounting", label:"Accounting"},
{value:'Finance', label:'Finance'},
{value:'Sales', label:'Sales'},
{value:'Research and Development', label:'Research and Development'},
{value:'IT', label:'IT'},
{value:'Management', label:'Management'},
{value:'Administration', label:'Administration'},
{value:'Customer support', label:'Customer support'},
{value:'Technical support', label:'Technical support'},
{value:'Marketing', label:'Marketing'},
{value:'Logistics', label:'Logistics'},
{value:'Operations', label:'Operations'},
{value:'Human resources', label:'Human resources'},
{value:'Purchasing', label:'Purchasing'},
{value:'Quality assurance', label:'Quality assurance'},
{value:'Engineering', label:'Engineering'},
{value:'Public relations', label:'Public relations'},
]

function Step1({currentUser, job}) {
  const modalBar = React.useContext(CustomModalContext)
  const [validated, setValidated] = useState(false);
  const [locationOptions,setLocationOptions] = useState([])
  const [validationError, setValidationError] = useState({});
  const [isLoading, setIsLoading] = useState(false)
  
  useEffect(() => {
      if (job?.referral_candidate) {
          setReferrals(job?.referral_candidate)
      }
      if (job?.location) {
          setLocation({value:9999,label:job?.location})
      }
      if(job?.name){
        setTitle(job?.name)
      }
      if(job?.skills){
        setMustHave(job?.skills)
      }
      if(job?.niceToHaveSkills){
        setNiceToHave(job?.niceToHaveSkills)
      }
      if(!locationDepartment && !job?.department){
        setLocationDepartment(industries[0].value)
      }
  }, [])

  useEffect(() => {
      job_description = job?.description ? job.description : description
  }, [])
  const handleClick = (event) => {
      const form = event.currentTarget
      if (form.checkValidity() === false) {
          event.preventDefault()
          event.stopPropagation()
      } else {
          if (job_description == '') {
              event.preventDefault()
              event.stopPropagation()
              setValidationError({...validationError,description:'Job description is required'})
          } else if (!location) {
              event.preventDefault()
              event.stopPropagation()
              setValidationError({...validationError,location:'Location is required'})
          } else {
              modalBar.setBarState({ activeCreateForm: 1 })
              setValidationError({})
              setDescription(job_description)
          }
      }
      setValidated(true)
  }
  const {
    title,
    setTitle,
    description,
    setDescription,
    musthave,
    setMustHave,
    nicetohave,
    setNiceToHave,
    emailStepOne,
    setEmailStepOne,
    location,
    setLocation,
    setReferrals,
    locationDepartment,
    setLocationDepartment,
  } = React.useContext(Step1Context)

  const handleEmailDefault = () => {
      if (job) {
          return job?.notificationemails ? job.notificationemails : emailStepOne
      } else {
          return emailStepOne
              ? emailStepOne
              : setEmailStepOne(currentUser.email)
      }
  }

  const handleKeyPress = async (value, callback) => {
      const url = `/filter_candidate_on_location`
      const formData = new FormData()
      formData.append('filter_word', value)
      setIsLoading(true)
      const response = await axios
          .post(url, formData)
          .then((res) => res)
          .catch((error) => console.log(error))
      const locationPreferrenceArray = response.data.filter.map(
          ({ id, state, city }) => {
              const capState = Util.capitalize(state)
              const capCity = Util.capitalize(city)
              return { value: id, label: `${capCity}, ${capState} (US)` }
          }
      )
      setLocationOptions(locationPreferrenceArray)
      callback(locationOptions)
      setIsLoading(false)
  }

  const handleEditorChange = (e) => {
      job_description = e
      e
          ? setValidationError({})
          : setErrorDescription('Job description is required')
  }
  const handleLocation = (event) => {
    setLocation(event)
    setValidationError({...validationError,location:null})
  }
    


return(
  <Form noValidate validated={validated} onSubmit={handleClick}>
    <Form.Row>
      <Form.Group as={Col} xs="12" controlId="validationCustom01">
        <Form.Label>Position Title<p className="required">*</p></Form.Label>
        <Form.Control type="text"
          onChange={e => {
            e.target.value.trim() ? setTitle(e.target.value) : setTitle('')
          }}
          value={title}
          required
        />
        <Form.Control.Feedback type="invalid">
          Title is required.
        </Form.Control.Feedback>
      </Form.Group>
      <Col xs={6}>
        <Form.Group>
          <Form.Label>Location<p className="required">*</p></Form.Label>
          <AsyncSelect
           isLoading={isLoading}
           isClearable={true}
           styles={colourStyles}
           loadOptions={handleKeyPress}
           placeholder="Search for location"
           onChange={handleLocation}
           value={location}
           />
          {validationError.location && <span className="errorRequired">
             {validationError.location}
          </span>}
        </Form.Group>
      </Col>
      <Col xs={6}>
        <Form.Group>
            <Form.Label>Job Department</Form.Label>
                    <Select
                        className="basic-single"
                        classNamePrefix="select"
                        isSearchable={true}
                        styles={colourStyles}
                        name="color"
                        menuPlacement="auto"
                        minMenuHeight={6}
                        onChange={(event) => setLocationDepartment(event.value)}
                        options={industries}
                        value={
                            (locationDepartment || job?.department)
                                ? industries.filter(
                                      (industrie) =>
                                      locationDepartment ? industrie.value === locationDepartment : industrie.value === job?.department
                                  )
                                : industries[0]
                        }
                    />
                </Form.Group>
            </Col>
      <Col xs={12}>
        <Form.Group>
          <Form.Label>Job Description<p className="required">*</p></Form.Label>
          <Editor
            initialValue={job?.description ? job.description : description}
            init={{
              min_height: 150,
              toolbar: 'undo redo | bold italic | alignleft aligncenter alignright | code',
            }}
            onEditorChange={(newText) => handleEditorChange(newText)}
          />
          <Form.Control.Feedback className={styles.addDescriptionEditor}>
            {validationError.description && validationError.description}        
          </Form.Control.Feedback>
        </Form.Group>
      </Col>
      <Col xs={12}>
        <Form.Group>
          <Form.Label>Must have skills<p className="required">*</p> 
          <span className="infoSpan">(Separated By Comma)</span></Form.Label>
          <Form.Control as="textarea" rows={3}
            className="form-control"
            type="textarea"
            onChange={e => {
              e.target.value.trim() ? setMustHave(e.target.value) : setMustHave('')
            }}
            rows={4}
            value={musthave}
            required
          />
          <Form.Control.Feedback type="invalid">
            Must have skills are required
          </Form.Control.Feedback>
        </Form.Group>
      </Col>
      <Col xs={12}>
        <Form.Group>
          <Form.Label>Nice to have skills<p className="required">*</p> <span className="infoSpan">(Separated By Comma)</span></Form.Label>
          <Form.Control as="textarea" rows={3}
            className="form-control"
            onChange={e => {
              e.target.value.trim() ? setNiceToHave(e.target.value) : setNiceToHave('')
            }}
            rows={4}
            value={nicetohave}
            required
          />
          <Form.Control.Feedback type="invalid">
            Nice to have skills are required
          </Form.Control.Feedback>
        </Form.Group>
      </Col>
      <Col xs={6}>
        <Form.Group>
          <Form.Label>Which Emails should the notifications for this job to sent to?<p className="required">*</p></Form.Label>
          <Form.Control type="email"
            onChange={e => {
              e.target.value.trim() ? setEmailStepOne(e.target.value) : setEmailStepOne('')
            }}
            rows={4}
            defaultValue={handleEmailDefault()}
            required
          />
          <Form.Control.Feedback type="invalid">
            Email is required
          </Form.Control.Feedback>
        </Form.Group>
      </Col>
      <Col xs={12}>
        {/* <Form.Group>
          <Form.Check
            type="checkbox"
            label="This Job is accepting referrals"
            onChange={(event) => setReferrals(event.target.checked)}
            checked={referrals}
          />
          { referrals &&
          <Form.Label>If yes, what is the commision for the sucessful hire of a referred candidate?
            <Form.Control type="text" placeholder="$" className={`${styles.referralCandidateValue}`}
              onChange={e => {
                e.target.value.trim() ? setMoney(e.target.value) : setMoney('')
              }}
              value={money}
              defaultValue={job?.referral_amount? job.referral_amount :money}
            required
          />
          <Form.Control.Feedback type="invalid">
            Referral value is required
          </Form.Control.Feedback>
            </Form.Label> }
        </Form.Group> */}
      </Col>
    </Form.Row>
  <Button variant="primary" type="submit" style={{marginRight:0}}>
    Next
  </Button>
</Form>
)}
export default Step1;