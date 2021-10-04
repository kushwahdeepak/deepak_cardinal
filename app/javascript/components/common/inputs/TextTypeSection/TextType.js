import React, { useEffect, useState, useRef } from "react"
import Row from "react-bootstrap/Row"
import FormControl from "react-bootstrap/FormControl"

function TagInput({
  setExperienceYears,
  handleSearch,
  experienceYears,
  jobSearch
}) {
  
  if(jobSearch){
    useEffect(()=>{
      setExperienceYears(jobSearch.experience_years)
    },[jobSearch.experience_years])
  }

  const handleSubmit=(e)=>{
    if(e.key === 'Enter'){
      handleSearch()
    }
  }

  return (
    <Row>
      <FormControl
  			id="basic-url-year"
  			aria-describedby="basic-addon3"
  			value={experienceYears}
  			onChange={(e) => setExperienceYears(e.target.value)}
  			onKeyPress={handleSubmit}
  			placeholder = 'Experience Year'
			/>
    </Row>
  )
}


export default TagInput
