import React from 'react';
import BooleanInput from '../../../../components/common/inputs/BooleanInput/BooleanInput';
import renderer from 'react-test-renderer';
import { configure, shallow, mount } from 'enzyme';
import Adapter from 'enzyme-adapter-react-16';
import { findByTestAttr } from '../../../../utils';

configure({adapter: new Adapter()});

const initialShallowRender = (props = {}) => {
	return shallow(<BooleanInput {...props}/>);
};

const initialMountRender = (props = {}) => {
	return mount(<BooleanInput {...props}/>);
};

describe('BooleanInput component',  () => {
	let wrapper;
	let fullWrapper;

	beforeEach(() => {

		const props = {
		};
		wrapper = initialShallowRender(props);
		fullWrapper = initialMountRender(props);
	});

	afterEach(() => {
		fullWrapper.unmount();
	});

	it('should render BooleanInput component', () => {
		expect(wrapper.exists()).toBe(true);
	});

	it('should match with a snapshot', () => {
		const component = renderer.create(<BooleanInput />);
		let tree = component.toJSON();
		expect(tree).toMatchSnapshot();
	});

	describe('BooleanInput component with props', () => {
		let wrapper;
		let fullWrapper;
		const setState = jest.fn();
		const useStateSpy = jest.spyOn(React, 'useState');
		useStateSpy.mockImplementation((init) => [init, setState]);

		beforeEach(() => {

			const props = {
				handleCheckboxChange: jest.fn(),
				testAttr: 'mockAttribute',
				setInputState: jest.fn(),
				label: 'mockLabel'
			};
			wrapper = initialShallowRender(props);
			fullWrapper = initialMountRender(props);
		});

		afterEach(() => {
			fullWrapper.unmount();
			jest.clearAllMocks();
		});

		it('should change checked for checkbox', () => {
			const checkboxItem = findByTestAttr(wrapper, 'checkbox-item').at(0);
			checkboxItem.simulate("change", { target: { checked: true } });
			expect(findByTestAttr(wrapper, 'checkbox-item').props().checked).toBe(true);
		});
		it('should call setInputState function', () => {
			expect(fullWrapper.props().setInputState).toHaveBeenCalledTimes(1);
		});

		it('should has correct testAttr prop', function () {
			const checkboxItem = findByTestAttr(wrapper, 'checkbox-item').at(0);
			expect(checkboxItem.props().id).toBe(fullWrapper.prop('testAttr'));
		});

		it('should has correct label text', function () {
			const labelItem = findByTestAttr(wrapper, 'label-item').at(0);
			expect(labelItem.text()).toBe(fullWrapper.prop('label'));
		});
	});
	describe('BooleanInput component without props', () => {

	});

});
