import React, { useContext,useState ,useEffect } from 'react'
import styles from './styles/EmployerOrganization.module.scss';
import Input from '../../common/Styled components/Input'
import ProfileUploader from '../CandidateProfilePage/ProfileUploader'
import { StoreCompanyContext } from '../../../stores/CompanyProfileStore'
import {Wrapper, ImageContainer, Row, W4text, W8text, InputContainer, Container, ScrollContainer, Button} from './styles/EditOrganization.styled'
import { Card, Col } from 'react-bootstrap'
import profileImage from '../../../../assets/images/img_avatar.png'
import Modal from 'react-bootstrap/Modal'
import crossButton from '../../../../assets/images/icons/crossbutton.png'
import { makeRequest } from '../../common/RequestAssist/RequestAssist'
import validator from 'validator'
import BlankOrganizationImage from '../../../../assets/images/organizationBlankImage.png';
import Alert from 'react-bootstrap/Alert'
import stateCities from 'state-cities'

function EditOrganization(props){
    const { format_logo_url, members, isOpenDetail, hideModalDetail, organization, renderSwitch} = props
    const {state, dispatch} = useContext(StoreCompanyContext)
    const [initialState, setState] = useState({...state})
    const {id, name, description, industry, min_size, max_size, region, city, country, logo_url, company_size, companySizes, industries} = initialState
    const [validationErrors, setValidationErrors] = useState([])
    const [companySizeList, setCompanySizeList] = useState([])
    const [industrySizeList, setIndustrySizeList] = useState([])
    const [states, setStates] = useState(stateCities.getStates())
    const [selectState, setSelectState] = useState(null)
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
          hideModalDetail(false)
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

    const handleOnRemove = async (id) => {

      const url =  'remove_member_from_organization'
      const formData = new FormData()
        formData.append('organization[member_id]', id)
        formData.append('organization[organization_id]', organization.id)
        const CSRF_Token = document
            .querySelector('meta[name="csrf-token"]')
            .getAttribute('content')

        try {
            await makeRequest(url,  'put', formData,{
                contentType: 'application/json',
                loadingMessage: 'Submitting...',
                createResponseMessage: (response) => {
                    return response.message
                },
            }).then((res) => {
                hideModalDetail(false)
                window.location.reload();
            })    
        } catch (e) {
            console.error(e.message)
        }
      
    }

    const onSelectState = (event) => {
        setSelectState(event.target.value)
        setCitys(stateCities.getCities(event.target.value))
    }

  const handleRegion = (e) => {
      handelInput(e)
      onSelectState(e)
  }

    return(
        <>
      <Modal size='xl'  show={isOpenDetail} onHide={hideModalDetail} animation={false}>
            <Modal.Body className="edit-organization-modal" >  
                <button style={{background:'none', border:'none'}} className='crossbutton' onClick={()=> hideModalDetail(false)}> <img  src={crossButton}  style={{height: '35px'}} /> </button> 
                <div className='edit-organization-modal__model-body'>
            		<div className='main-panel-modal'>
                		<h1 className='organization-title'>Edit Organization Details</h1>  
                         <Wrapper>
                            <Container direction="column" style={{height:"100%"}}>
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
                                    <ScrollContainer>
                                        <Row direction="row">
                                        <Container direction="column" jContent="space-between" flex="2">
                                            <W4text size="12px" color="#7A8AC2" style={{ alignSelf: 'flex-start', marginBottom: '8px',}}>
                                                Company Picture
                                            </W4text>
                                            <ImageContainer>
                                                <img src={logo_url == null ? BlankOrganizationImage : format_logo_url(logo_url)} />
                                            </ImageContainer>
                                            <div  style={{ marginLeft: '12px' }}>
                                                <ProfileUploader
                                                onFileSelectSuccess={(file) =>
                                                    handlePicture(file)
                                                }
                                                onFileSelectError={({ error }) => alert(error)}
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
                                            label="Company Name"
                                            type="text"
                                            maxLength={100}
                                            onChange={(e) => {handelInput(e)
                                              renderSwitch(e)}}
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
                                            label="Company Industry"
                                            onChange={handelInput}
                                        />
                                        </InputContainer>
                                        <InputContainer width="40.5%">
                                        <Input
                                            options={companySizeList}
                                            value={company_size}
                                            label="Company Size"
                                            name="company_size"
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
                                        type="textarea"
                                        onChange={handelInput}
                                    />
                                </Row>
                            </ScrollContainer>
                        </Container>
                    </Wrapper>
                    <div className='container'>           
                        <h1 className='organization-sub-title'>Edit Organization Details</h1>
                            <Row xs={12}>
                                {members?.map((member) => {
                                    const member_name = member.first_name +' ' + member.last_name  
                                    return(
                                        <Col xs={4} key={member.id} >
                                            <Card className='employer-card'>
                                            <Card.Body >
                                                <div>
                                                    <div className='row'>
                                                        <img  className={`${styles.MemberProfileImage}`} src={member ? profileImage : profileImage} />
                                                        <div className='container' style={{ margin: '-26px -32px'}}>
                                                            <h6 className={`${styles.MemberName}`}>{member_name }</h6>
                                                            <h6  className={`${styles.MemberDesignation}`} style={{fontSize: '16px'}}>{member.role }</h6>
                                                                <div>
                                                                  {(member?.id == organization?.owner_id ? false : true) &&
                                                                    <button
                                                                      onClick={()=>
                                                                         {handleOnRemove(member.id)
                                                                         handleOnSave()}
                                                                      }
                                                                      className={`${styles.MemberRemove}`}
                                                                    > 
                                                                        Remove 
                                                                    </button>
                                                                  }
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </Card.Body>
                                            </Card>     
                                            </Col>
                                        )
                                    }) || ''}
                                    
                                </Row>
                                <Row direction="row" jContent="flex-end">
                                    <Button onClick={handleOnSave} lr="16px" tb="5px">
                                        <W8text size="14px" color="#ffff">
                                            Save Changes
                                        </W8text>
                                     </Button>
                                </Row>
                            </div> 
                            </div>
    		            </div>
            </Modal.Body>
        </Modal>
      </>

    )
}

export default EditOrganization;
