package nagyHazi;


import jason.architecture.AgArch;
import jason.asSemantics.ActionExec;
import jason.asSyntax.ASSyntax;
import jason.asSyntax.Literal;
import jason.asSyntax.Term;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.ArrayList;
import java.util.List;

import javax.swing.GroupLayout;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.JTextArea;
import javax.swing.JTextField;


public class GUI extends AgArch {

	JTextArea jt;
	JFrame    f;
	JButton createConnectionBtn;
	JButton dropConnectionBtn;
	JComboBox<String> fromBox;
	JComboBox<String> toBox;
	JTextField weightField;

	List<String> agentList;

	public GUI() {

		fromBox = new JComboBox<String>();
		toBox = new JComboBox<String>();
		weightField = new JTextField("5");
		
		createConnectionBtn = new JButton("Add connection");
		createConnectionBtn.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {

				Literal goal = ASSyntax.createLiteral("create_connection");
				goal.addTerms(ASSyntax.createString((String)fromBox.getSelectedItem()));
				goal.addTerms(ASSyntax.createString((String)toBox.getSelectedItem()));
				goal.addTerms(ASSyntax.createNumber(Integer.parseInt(weightField.getText())));
				getTS().getC().addAchvGoal(goal, null);


			}
		});

		dropConnectionBtn = new JButton("Drop connection");
		dropConnectionBtn.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {

				Literal goal = ASSyntax.createLiteral("drop_connection");
				goal.addTerms(ASSyntax.createString((String)fromBox.getSelectedItem()));
				goal.addTerms(ASSyntax.createString((String)toBox.getSelectedItem()));
				getTS().getC().addAchvGoal(goal, null);

			}
		});

		JPanel mainPanel = new JPanel();
		GroupLayout layout = new GroupLayout(mainPanel);
		mainPanel.setLayout(layout);

		layout.setHorizontalGroup(
				layout.createParallelGroup(GroupLayout.Alignment.LEADING)
				.addGroup(layout.createSequentialGroup()
						.addComponent(fromBox)
						.addComponent(toBox)
						.addComponent(weightField))
				.addGroup(layout.createSequentialGroup()
						.addComponent(createConnectionBtn)
						.addComponent(dropConnectionBtn))
				);
		layout.setVerticalGroup(
				layout.createSequentialGroup()
				.addGroup(layout.createParallelGroup(GroupLayout.Alignment.BASELINE)
						.addComponent(fromBox)
						.addComponent(toBox)
						.addComponent(weightField))
				.addGroup(layout.createParallelGroup(GroupLayout.Alignment.BASELINE)
						.addComponent(createConnectionBtn)
						.addComponent(dropConnectionBtn)
						));

		f = new JFrame("Simulator");
		f.getContentPane().add(mainPanel);
		f.pack();
		f.setVisible(true);
	}

	@Override
	public void act(ActionExec action, List<ActionExec> feedback) {
		if (action.getActionTerm().getFunctor().startsWith("tell_agents")) {
			this.agentList = new ArrayList<String>();
			fromBox.removeAllItems();
			toBox.removeAllItems();
			for(Term term :action.getActionTerm().getTerms())
			{
				String a = term.toString();
				a = a.replace("]", "");
				a = a.replace("[", "");
				String [] agents = a.split(",");
				for(String agent : agents)
				{
					if(!agent.equals("env"))
					{
						agentList.add(agent);
						fromBox.addItem(agent);
						toBox.addItem(agent);
					}
				}
			}
			action.setResult(true);
			feedback.add(action);

		} else {
			super.act(action,feedback); // send the action to the environment to be performed.
		}
	}


	private void addEdge(String node1, String node2, int cost)
	{

	}

	private void removeEdge(String node1, String node2)
	{

	}

	@Override
	public void stop() {
		f.dispose();
		super.stop();
	}
}
