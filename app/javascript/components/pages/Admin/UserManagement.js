import React, { useState, useEffect } from 'react'
import styled from 'styled-components'

import Card from './shared/Card'
import Table from './shared/Table'
import Paginator from '../../common/Paginator/Paginator'
import { makeRequest } from '../../common/RequestAssist/RequestAssist'
import Button from './shared/Button'
import P from './shared/P'
import TableWrapper from './shared/TableWrapper'
import SearchBar from '../../common/SearchBar/SearchBar'
import moment from 'moment'

const A = styled.a`
    font-family: Avenir;
    font-style: normal;
    font-weight: normal;
    font-size: 14px;
    line-height: 19px;
    color: #7288ff;
    cursor: pointer;
    margin-left: 16px;
`

const UserManagement = () => {
    const [activePage, setActivePage] = useState(0)
    const [pageCountUsers, setPageCountUsers] = useState(0)
    const [pageCountAdmins, setPageCountAdmins] = useState(0)
    const [users, setUsers] = useState([])
    const [admins, setAdmins] = useState([])
    const [showAdmins, setShowAdmins] = useState(false)
    const [addNewRow, setAddNewRow] = useState(null)
    const [searchTerm, setSearchTerm] = useState('')

    const fetchData = async () => {
        const url = 'get_users_and_admins'
        const response = await makeRequest(
            `${url}?page=${activePage + 1}&search=${searchTerm}`,
            'get',
            {}
        )
        setUsers(
            response.data.users.map((user) => ({
                id: user.id,
                name: user.first_name + ' ' + user.last_name,
                email: user.email,
                role: user.role,
                created_at: user.created_at,
                status: user.email_confirmed ? 'Approved' : 'Pending',
            }))
        )
        setAdmins(
            response.data.admins.map((admin) => ({
                id: admin.id,
                name: admin.first_name + ' ' + admin.last_name,
                email: admin.email,
                created_at: admin.created_at,
            }))
        )
        setPageCountUsers(response.data.total_pages_users)
        setPageCountAdmins(response.data.total_pages_admins)
    }

    useEffect(() => {
        fetchData()
        window.scrollTo({ top: 0, behavior: 'smooth' })
    }, [activePage])

    const deleteUser = async (id) => {
        if (showAdmins) {
            setAdmins(admins.filter((a) => a.id != id))
        } else {
            setUsers(users.filter((r) => r.id != id))
        }
        setAddNewRow(null)

        if (id == -1) return
        const url = `/admin/users/${id}`
        const response = await makeRequest(url, 'delete', {
            contentType: 'application/json',
            loadingMessage: 'Submitting...',
            createSuccessMessage: (response) => response.data.message,
        })
    }

    const saveUser = async (newUser) => {
        const userId = newUser.data.id
        if (showAdmins) {
            const url = userId == -1 ? 'admins' : `admins/${userId}`
            const type = userId == -1 ? 'post' : 'put'

            const response = await makeRequest(url, type, newUser.data, {
                contentType: 'application/json',
                loadingMessage: 'Submitting...',
                createSuccessMessage: (response) => response.data.message,
                onSuccess: () => {
                  fetchData()
                },
            })
        } else {
            const url = `users/${userId}`
            const response = await makeRequest(url, 'put', newUser.data, {
                contentType: 'application/json',
                loadingMessage: 'Submitting...',
                createSuccessMessage: (response) => response.data.message,
                onSuccess: () => {
                  fetchData()
                },
            })
        }
    }

    const addAdmin = () => {
        const emptyAdmin = {
            id: -1,
            name: '',
            email: '',
            created_at: moment(new Date()).format('YYYY-MM-DD'),
        }
        setAdmins([emptyAdmin, ...admins])
        setAddNewRow(1)
    }

    return (
        <Card>
            <div
                className="d-flex justify-content-between align-items-center w-100"
                style={{ marginBottom: '42px' }}
            >
                <P size="28px" height="38px" color="#1D2447">
                    User Management
                </P>
                <SearchBar
                    placeholder="Search users..."
                    value={searchTerm}
                    onChange={(e) => setSearchTerm(e.target.value)}
                    onEnterPressed={() => {
                        activePage === 0 ? fetchData() : setActivePage(0)
                    }}
                    onButtonClick={() => {
                        activePage === 0 ? fetchData() : setActivePage(0)
                    }}
                />
                <Button
                    onClick={() => {
                        setShowAdmins(true)
                        setActivePage(0)
                    }}
                    className="ml-3"
                >
                    Manage Admins
                </Button>
            </div>
            {showAdmins ? (
                <TableWrapper>
                    <div
                        className="d-flex justify-content-between align-items-center w-100"
                        style={{ marginBottom: '18px    ' }}
                    >
                        <P size="22px" height="30px" color="#1D2447">
                            Manage Admins <A onClick={addAdmin}>+ Add Admins</A>
                        </P>
                        <Button
                            onClick={() => {
                                setShowAdmins(false)
                                setAddNewRow(0)
                                setAdmins(admins.filter((a) => a.id != -1))
                            }}
                            padding="1px 10px"
                            height="30px"
                            width="30px"
                            radius="15px"
                            background="#8599FF"
                        >
                            x
                        </Button>
                    </div>
                    <Table
                        columNames={[
                            {
                                name: 'No.',
                                field: 'id',
                                editable: false,
                                type: 'text',
                            },
                            {
                                name: 'Admin Name',
                                field: 'name',
                                editable: true,
                                type: 'text',
                            },
                            {
                                name: 'Email',
                                field: 'email',
                                editable: true,
                                type: 'text',
                            },
                            {
                                name: 'Admin Since',
                                field: 'created_at',
                                editable: false,
                                type: 'text',
                            },
                            {
                                name: 'Options',
                                field: 'options',
                                editable: false,
                                type: 'text',
                            },
                        ]}
                        showEditOption
                        rowValues={admins.map((o) => ({
                            ...o,
                            created_at: moment(o.created_at).format(
                                'YYYY-MM-DD'
                            ),
                        }))}
                        deleteAction={deleteUser}
                        saveAction={saveUser}
                        addNewRow={addNewRow}
                        activePage={activePage}
                        goToEditPage={(id) =>
                            (window.location.href = '/admin/users/' + id)
                        }
                    />
                </TableWrapper>
            ) : (
                <Table
                    columNames={[
                        {
                            name: 'No.',
                            field: 'id',
                            editable: false,
                            type: 'text',
                        },
                        {
                            name: 'User Name',
                            field: 'name',
                            editable: true,
                            type: 'text',
                        },
                        {
                            name: 'Email',
                            field: 'email',
                            editable: true,
                            type: 'text',
                        },
                        {
                            name: 'Role',
                            field: 'role',
                            editable: true,
                            type: 'select',
                        },
                        {
                            name: 'Joined On',
                            field: 'created_at',
                            editable: false,
                            type: 'text',
                        },
                        {
                            name: 'Status',
                            field: 'status',
                            editable: false,
                            type: 'text',
                        },
                        {
                            name: 'Options',
                            field: 'options',
                            editable: false,
                            type: 'text',
                        },
                    ]}
                    showEditOption
                    rowValues={users.map((o) => ({
                        ...o,
                        created_at: moment(o.created_at).format('YYYY-MM-DD'),
                    }))}
                    deleteAction={deleteUser}
                    saveAction={saveUser}
                    activePage={activePage}
                    goToEditPage={(id) =>
                        (window.location.href = '/admin/users/' + id)
                    }
                />
            )}

            {(showAdmins ? pageCountAdmins : pageCountUsers) > 1 && (
                <div
                    className="d-flex justify-content-center"
                    style={{ marginTop: 'auto' }}
                >
                    <Paginator
                        activePage={activePage}
                        setActivePage={setActivePage}
                        pageCount={
                            showAdmins ? pageCountAdmins : pageCountUsers
                        }
                        pageWindowSize={5}
                        showGoToField={false}
                    />
                </div>
            )}
        </Card>
    )
}

export default UserManagement
