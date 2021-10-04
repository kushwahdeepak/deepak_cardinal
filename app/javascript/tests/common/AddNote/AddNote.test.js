import React from 'react';
import AddNote from '../../../components/common/AddNote/AddNote';
import renderer from 'react-test-renderer';
import { configure, shallow, mount } from 'enzyme';
import Adapter from 'enzyme-adapter-react-16';
import { findByTestAttr, wait } from '../../../utils';

configure({adapter: new Adapter()});

const initialShallowRender = (props = {}) => {
	return shallow(<AddNote {...props}/>);
};

const initialMountRender = (props = {}) => {
	return mount(<AddNote {...props}/>);
};

const initialProps = {
};

describe('AddNote component',  () => {
	let wrapper;
	let fullWrapper;

	beforeEach(() => {

		const props = {
			...initialProps,
			show: true
		};

		wrapper = initialShallowRender(props);
		fullWrapper = initialMountRender(props);
	});

	afterEach(() => {
		fullWrapper && fullWrapper.unmount();
	});

	it('should render AddNote component', () => {
		expect(wrapper.exists()).toBe(true);
	});

	it('should has modal wrapper', () => {
		expect(findByTestAttr(wrapper, 'modal-wrapper').length).toBe(1);
	});

	it('should match with a snapshot', () => {
		const component = renderer.create(<AddNote {...initialProps} />);
		let tree = component.toJSON();
		expect(tree).toMatchSnapshot();
	});

	describe('AddNote component with props', () => {
		let wrapper;
		let fullWrapper;

		beforeEach(() => {

			const props = {
				...initialProps,
				onHide: jest.fn(),
				show: true
			};

			wrapper = initialShallowRender(props);
			fullWrapper = initialMountRender(props);
		});

		afterEach(() => {
			jest.clearAllMocks();
		});

		it('should call close click function once', () => {
			const closeButton = findByTestAttr(fullWrapper, 'close-button').at(0);
			closeButton.simulate('click');
			expect(fullWrapper.props().onHide).toHaveBeenCalledTimes(1);
		});

		it('should have the expected content', async () => {
			const addButton = findByTestAttr(fullWrapper, 'add-modal-btn').at(0);
			const closeButton = findByTestAttr(fullWrapper, 'close-button').at(0);
			const modalWrapper = findByTestAttr(fullWrapper, 'modal-wrapper').at(0);
			expect(addButton.exists()).toBeTruthy();
			expect(closeButton.exists()).toBeTruthy();
			expect(modalWrapper.exists()).toBeTruthy();
		});

		it('should click on the button', async () => {
			const closeButton = () => findByTestAttr(fullWrapper, 'close-button').at(0);
			closeButton().simulate('click');
			await wait(500);
			fullWrapper.update();

			const modalWrapper = () => findByTestAttr(fullWrapper, 'modal-wrapper').at(0);
			expect(modalWrapper()).toEqual({});
		});

		it.skip('should handle the correct value in textarea', () => {
			const textAreaItem = findByTestAttr(fullWrapper, 'text-area-item').at(0).find('textarea');
			textAreaItem.simulate('change', {
				value: 'Mock value'
			});
			const updatedTextArea = findByTestAttr(fullWrapper, 'text-area-item').at(0).find('textarea');
			expect(updatedTextArea.props().value).toBe('Mock value');
		});
	});
	describe('AddNote component without props', () => {
		let wrapper;
		let fullWrapper;

		beforeEach(() => {

			const props = {
				...initialProps,
				onHide: jest.fn(),
				show: false
			};

			wrapper = initialShallowRender(props);
			fullWrapper = initialMountRender(props);
		});
	});

});
