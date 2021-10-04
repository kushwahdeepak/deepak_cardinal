import React, { useContext, useEffect, useState } from 'react'
import Alert from 'react-bootstrap/Alert'
import validator from 'validator'
import stateCities from 'state-cities'

import CloseButton from '../../common/Styled components/CloseButton'
import Input from '../../common/Styled components/Input'
import CandidateTwoImage from '../../../../assets/images/img_avatar.png'
import ProfileUploader from '../CandidateProfilePage/ProfileUploader'
import { StoreCompanyContext } from '../../../stores/CompanyProfileStore'
import {Wrapper, ImageContainer, Row, W4text, W8text, InputContainer, Container, ScrollContainer, Button} from './styles/CompanyProfilePage.styled'

function EditCompanyProfile(props){
    const { open, setOpen, format_logo_url, organization} = props
    const {state, dispatch} = useContext(StoreCompanyContext)
    const [initialState, setState] = useState({...state})
    const {id, name, description, industry, min_size, max_size, region,city,country, logo_url, company_size, companySizes, industries} = initialState
    const [validationErrors, setValidationErrors] = useState([])
    const [companySizeList, setCompanySizeList] = useState([])
    const [industrySizeList, setIndustrySizeList] = useState([])
    const [states, setStates] = useState(stateCities.getStates())
    const [selectState, setSelectState] = useState(region)
    const [citys, setCitys] = useState(null)
    
    useEffect(() => {
      if(organization.region) {
        setSelectState(organization.region)
      }
    } ,[])

    useEffect(() => {
        const lookupsUrl = '/signup/lookups'
        fetch(lookupsUrl)
            .then((res) => res.json())
            .then(
                (result) => {
                    setCompanySizeList(result.company_sizes)
                    setIndustrySizeList(result.industries)
                },
                (error) => {
                    console.log(error)
                }
            )
        setStates(stateCities.getStates())
        setCitys(stateCities.getCities(region))
    }, [])

    const handlePicture = (file) => {
      if (file && file.size > 1024 * 1024 * 4) {
        handlePictureError('Image File size cannot exceed more than 4MB')
      } else {
        let errors = []
            setValidationErrors(errors)
        setState({...initialState, logo_url: file})
      }
    }

    const handelInput = (event) => {
      const {name, value} = event.target
      setState({...initialState, [name]: value})
    }

    const handleOnSave = () => {
      const valid = !!(
          name.length &&
          validator.trim(name)
      )
      if (valid) {
        dispatch({type: 'update_company_profile', value: initialState})
        setOpen(false)
      }else{
          setValidationMessages()
      }
    }

    const setValidationMessages = () => {
      let errors = []
      if (
          !(
              name.length &&
              validator.trim(name)
          )
      )
          errors.push('Company Name is required')
      setValidationErrors(errors)
    }
    const handlePictureError = (error) => {
      let errors = []
      errors.push(error)
      setValidationErrors(errors)
    }

    const handleRegion = (e) => {
        handelInput(e)
        onSelectState(e)
    }


    const onSelectState = (event) => {
        setSelectState(event.target.value)
        setCitys(stateCities.getCities(event.target.value))
    }
        
    return(
      <Wrapper>
        <Container direction="column" style={{height:"100%"}}>
          <Row direction="row" jContent="space-between">
                    <W4text size="32px" color="#1D2447">
                        Edit Organizations Profile
                    </W4text>
                    <CloseButton handleClick={() => setOpen(!open)} />
                </Row>
          <ScrollContainer>
          {validationErrors.length > 0 && (
                <Alert
                    variant="danger"
                    onClose={() => setValidationErrors([])}
                    dismissible
                >
                    {validationErrors.map((error, idx) => (
                        <p key={idx} className="mb-0">
                            {error}
                        </p>
                    ))}
                </Alert>
            )}
            <Row direction="row">
              <Container direction="column" jContent="space-between" flex="2">
                <W4text size="12px" color="#7A8AC2" style={{ alignSelf: 'flex-start', marginBottom: '8px',}}>
                Organizations Picture
                </W4text>
                <ImageContainer>
                    <img src={logo_url == null ? CandidateTwoImage : format_logo_url(logo_url)} />
                </ImageContainer>
                
                <div  style={{ marginLeft: '12px' }}>
                <ProfileUploader
                  onFileSelectSuccess={(file) =>
                    handlePicture(file)
                  }
                  onFileSelectError={({ error }) => handlePictureError(error)}
                  isProfilePicture={'profilePicture'}
                />
                </div>
              </Container>
              <Container
                direction="row"
                flex="10"
                jContent="space-around"
              >
                <InputContainer width="90%">
                  <Input
                      value={name}
                      name="name"
                      label="Organizations Name"
                      isValid={true}
                      type="text"
                      maxLength={100}
                      onChange={handelInput}
                      
                  />
                </InputContainer>
                <InputContainer width="23.5%">
                  <Input
                    label="Country"
                    value="USA"
                    name="country"
                    type="text"
                    maxLength={100}
                    onChange={handelInput}
                    readOnly="true"
                  />
                </InputContainer>
                <InputContainer width="23.5%">
                  <Input
                    type="select-custom"
                    options={states}
                    value={selectState}
                    name="region"
                    label="State"
                    onChange={handleRegion}
                  />
                </InputContainer>
                <InputContainer width="23.5%">
                  <Input
                    type="select-custom"
                    options={citys}
                    value={city}
                    name="city"
                    label="City"
                    onChange={handelInput}
                  />
                </InputContainer>
                <InputContainer width="40.5%">
                  <Input
                    type="select"
                    options={industrySizeList}
                    value={industry}
                    name="industry"
                    label="Industry"
                    isValid={true}
                    onChange={handelInput}
                  />
                </InputContainer>
                <InputContainer width="40.5%">
                  <Input
                      options={companySizeList}
                      value={company_size}
                      label="Organizations Size"
                      name="company_size"
                      isValid={true}
                      type="select"
                      onChange={handelInput}
                  />
                </InputContainer>
              </Container>
            </Row>
            <Row direction="row">
              <Input
                value={description}
                label="About Organization"
                name="description"
                isValid={true}
                type="textarea"
                onChange={handelInput}
                maxLength="500"
              />
            </Row>
          </ScrollContainer>
          <Row direction="row" jContent="flex-end">
            <Button onClick={handleOnSave} lr="16px" tb="5px">
              <W8text size="14px" color="#ffff">
                  Save Changes
              </W8text>
            </Button>
          </Row>
        </Container>
      </Wrapper>
    )
}

export default EditCompanyProfile;