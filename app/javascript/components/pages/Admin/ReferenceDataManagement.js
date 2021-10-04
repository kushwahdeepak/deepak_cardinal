import React, { useState, useEffect, useRef } from 'react'
import { OverlayTrigger, Image } from 'react-bootstrap'

import Card from './shared/Card'
import P from './shared/P'
import EditIcon from '../../../../assets/images/icons/pencil-icon-v2.svg'
import DeleteIcon from '../../../../assets/images/icons/trash-icon-v2.svg'
import Paginator from '../../common/Paginator/Paginator'
import CustomRichTextarea from '../../common/inputs/CustomRichTextarea/CustomRichTextarea'
import { makeRequest } from '../../common/RequestAssist/RequestAssist'
import {
    CustomDropdown,
    Header,
    Row,
    A,
    PopupCard,
    Input,
} from './styles/ReferenceDataManagement.styled'

const CATEGORIES = [
    { key: 'companies', name: 'Companies', lookup: true },
    { key: 'skills', name: 'Skills', lookup: true },
    { key: 'titles', name: 'Titles', lookup: true },
    { key: 'locations', name: 'Locations', lookup: true },
    { key: 'terms_and_conditions', name: 'Terms & Conditions', contractName: 'terms_and_conditions'  },
    { key: 'privacy_policy', name: 'Privacy Policy', contractName: 'privacy_policy' },
    { key: 'recruiting_agreement', name: 'Recruiting Agreement', contractName: 'recruiting_agreement', role: 'recruiter' },
    { key: 'employer_agreement', name: 'Employer Agreement', contractName: 'recruiting_agreement', role: 'employer' },
]

const ReferenceDataManagement = () => {
    const [activePage, setActivePage] = useState(0)
    const [pageCount, setPageCount] = useState(0)
    const [selectedCategory, setSelectedCategory] = useState(CATEGORIES[0])
    const [showAddRow, setShowAddRow] = useState(false)
    const [action, setAction] = useState(null)
    const [editRow, setEditRow] = useState(null)
    const [editInput, setEditInput] = useState('')
    const [editTextarea, setEditTextarea] = useState('')
    const [loading, setLoading] = useState(true)
    const [data, setData] = useState([])

    const inputRef = useRef()

    useEffect(() => {
        fetchData()
    }, [selectedCategory, activePage])

    const fetchData = () => {
        setLoading(true)
        if (selectedCategory.lookup) {
            fetchLookupData()
            setLoading(false)
        } else {
            fetchContractData()
        }
    }

    const fetchLookupData = () => {
        const url = `/lookups?name=${selectedCategory.key}&page=${activePage+1}`

        makeRequest(url, 'get', '').then((response) => {
            if (response.data) {
                setPageCount(response.data.total_pages)
                setData([ ...response.data.items ])
            } else {
                    setData([])
            }
            setLoading(false)
        })
    }

    const fetchContractData = () => {
        let url = `/signup/contracts?name=${selectedCategory.contractName}`
        if (selectedCategory.role) {
            url = `${url}&role=${selectedCategory.role}`
        }
        makeRequest(url, 'get', '').then((response) => {
            if (response.data && response.data.content) {
                    setData([{
                        id: response.data.id,
                        name: response.data.content,
                    }])
            } else {
                    setData([])
            }
            setLoading(false)
        })
    }

    const saveContract = (content) => {
        const formData = new FormData()
        formData.append('name', selectedCategory.key)
        formData.append('content', content)
        if (selectedCategory.role) {
            formData.append('role', selectedCategory.role)
        }

        const url = '/sign_up_contracts/update_or_create'
        makeRequest(url, 'put', formData, {
            createSuccessMessage: () => `${selectedCategory.name} created successfully`,
            onSuccess: () => {
                fetchContractData()
            },
        })
    }

    const addItem = (e) => {
        if (e.key === 'Enter') {
            // to do call backend to add item
            setShowAddRow(false)
            
            if (selectedCategory.lookup) {
                const lookup = {
                    name: selectedCategory.key,
                    key: e.target.value.toLowerCase(),
                    value: e.target.value
                }
                const formData = new FormData()
                formData.append('lookup[name]', lookup.name)
                formData.append('lookup[key]', lookup.key)
                formData.append('lookup[value]', lookup.value)

                const url = '/lookups'
                makeRequest(url, 'post', formData, {
                  createSuccessMessage: () => `${selectedCategory.name} created successfully`,
                  onSuccess: () => {
                    fetchLookupData()
                  },
                })
            } else {
                saveContract(e.target.value)
            }

            e.target.value = ''
        }
    }

    const updateItem = (e) => {
        if (e.key === 'Enter') {
            if (selectedCategory.lookup) {
                const lookup = {
                    id: editRow,
                    value: e.target.value
                }
                const formData = new FormData()
                formData.append('lookup[value]', lookup.value)

                const url = `/lookups/${lookup.id}`
                makeRequest(url, 'put', formData, {
                    createResponseMessage: (response) => {
                        return {
                            message: `${selectedCategory.name} updated successfully`,
                            messageType: 'success',
                            loading: false,
                            autoClose: true,
                        }
                    },
                    onSuccess: () => {
                        fetchLookupData()
                    },
                })
            } else {
                saveContract(e.target.value)
            }

            setEditRow(false)
        }
        setEditInput(e.target.value)
    }

    const handleDelete = () => {
        setAction(null)
        setData([
            ...data.filter(
                (c) => c.id != action.data.id
            )
        ])
        if (action.data.id == -1) return
        const url = `/lookups/${action.data.id}`
        const response = makeRequest(url, 'delete', {
            contentType: 'application/json',
            loadingMessage: 'Submitting...',
            createResponseMessage: (response) => {
                return {
                    message: response.data
                        ? response.data.message
                        : 'Delete successful',
                    messageType: 'success',
                    loading: false,
                    autoClose: true,
                }
            },
        })
    }

    const handleCategoryChange = (category) => {
        setSelectedCategory(category)
        setActivePage(0)
        setPageCount(0)
        setShowAddRow(false)
        setEditRow(null)
    }

    const popover = (
        <PopupCard id="popover-basic">
            <PopupCard.Content>
                <P size="14px" height="19px" center>
                    Are you sure you want to delete?
                </P>
                <div
                    style={{
                        marginTop: '15px',
                        display: 'flex',
                        justifyContent: 'space-around',
                    }}
                >
                    <A onClick={handleDelete}>Yes</A>
                    <A
                        onClick={() => setAction(null)}
                        style={{ marginLeft: '60px' }}
                    >
                        No
                    </A>
                </div>
            </PopupCard.Content>
        </PopupCard>
    )

    return (
        <Card>
            <div
                className="d-flex justify-content-between align-items-center w-100"
                style={{ marginBottom: '42px' }}
            >
                <P size="28px" height="38px" color="#1D2447">
                    Reference Data Management
                </P>
                <CustomDropdown>
                    <CustomDropdown.Toggle id="dropdown-basic">
                        <P size="18px" height="25px" color="#fff">
                            {selectedCategory.name}
                        </P>
                    </CustomDropdown.Toggle>

                    <CustomDropdown.Menu>
                        {CATEGORIES.map((c) => (
                            <CustomDropdown.Item
                                key={c.key}
                                onSelect={handleCategoryChange.bind(null, c)}
                            >
                                <P size="12px" height="19px" color="#1D2447">
                                    {c.name}
                                </P>
                            </CustomDropdown.Item>
                        ))}
                    </CustomDropdown.Menu>
                </CustomDropdown>
            </div>
            {!loading && (
                <Header>
                    <P size="18px" height="25px">
                        {selectedCategory.name}
                    </P>
                    {selectedCategory.lookup ? (
                        <A onClick={() => setShowAddRow((prev) => !prev)}>
                            + Add{' '}
                            {selectedCategory.name}
                        </A>
                    ) : (
                        data && data.length == 0 && (
                            <A onClick={() => setShowAddRow((prev) => !prev)}>
                                + Add{' '}
                                {selectedCategory.name}
                            </A>
                        )
                    )}
                </Header>
            )}
            {showAddRow && (
                <Row
                    style={{
                        boxShadow: '0px 4px 10px rgba(0, 0, 0, 0.1)',
                        width: '102%',
                    }}
                >
                    {selectedCategory.lookup ? (
                        <Input
                            type="text"
                            autoFocus
                            onKeyPress={addItem}
                            ref={inputRef}
                        />
                    ) : (
                        <CustomRichTextarea
                            handleContentChange={(value) =>
                                setEditTextarea(value)
                            }
                            styles={{
                                textTransform: 'none',
                                width: '100%',
                            }}
                        />
                    )}

                    <A
                        onClick={() =>
                            addItem({
                                key: 'Enter',
                                target: selectedCategory.lookup
                                    ? { value: inputRef.current.value }
                                    : { value: editTextarea },
                            })
                        }
                        style={{ marginLeft: '36px' }}
                    >
                        Save
                    </A>
                    <A
                        onClick={() => setShowAddRow(false)}
                        style={{ marginLeft: '36px' }}
                    >
                        Cancel
                    </A>
                </Row>
            )}
            {!loading && data && data.map((category) => (
                <Row
                    key={category.id}
                    style={
                        editRow == category.id
                            ? {
                                  boxShadow: '0px 4px 10px rgba(0, 0, 0, 0.1)',
                                  width: '102%',
                              }
                            : {}
                    }
                >
                    {editRow == category.id ? (
                        selectedCategory.lookup ? (
                            <Input
                                type="text"
                                defaultValue={category.name}
                                autoFocus
                                onKeyUp={updateItem}
                            />
                        ) : (
                            <CustomRichTextarea
                                fieldValue={category.name}
                                handleContentChange={(value) =>
                                    updateItem({
                                        target: { value },
                                    })
                                }
                                styles={{
                                    textTransform: 'none',
                                    width: '100%',
                                }}
                            />
                        )
                    ) : (
                        <P
                            size="14px"
                            height="19px"
                            dangerouslySetInnerHTML={{ __html: category.name }}
                        />
                    )}

                    <div style={{ display: 'flex', marginLeft: '10px' }}>
                        {editRow == category.id ? (
                            <>
                                <A
                                    onClick={(e) =>
                                        updateItem({
                                            key: 'Enter',
                                            target: { value: editInput },
                                        })
                                    }
                                >
                                    Save
                                </A>
                                <A
                                    onClick={() => {
                                        setEditRow(null)
                                    }}
                                    style={{ marginLeft: '36px' }}
                                >
                                    Cancel
                                </A>
                            </>
                        ) : (
                            <>
                                <A
                                    onClick={() => {
                                        setEditRow(editRow ? null : category.id)
                                    }}
                                >
                                    <Image src={EditIcon} />
                                </A>
                                <OverlayTrigger
                                    trigger="click"
                                    overlay={popover}
                                    placement="bottom"
                                    show={
                                        action && action.data.id === category.id
                                    }
                                >
                                    <A
                                        onClick={() => {
                                            setAction({
                                                type: 'delete',
                                                data: category,
                                            })
                                        }}
                                        style={{
                                            marginLeft: '15px',
                                        }}
                                    >
                                        <Image src={DeleteIcon} />
                                    </A>
                                </OverlayTrigger>
                            </>
                        )}
                    </div>
                </Row>
            ))}

            {pageCount > 1 && (
                <div
                    className="d-flex justify-content-center"
                    style={{ marginTop: 'auto' }}
                >
                    <Paginator
                        activePage={activePage}
                        setActivePage={setActivePage}
                        pageCount={pageCount}
                        pageWindowSize={5}
                        showGoToField={false}
                    />
                </div>
            )}
        </Card>
    )
}

export default ReferenceDataManagement
