import pulp
prob = pulp.LpProblem("diet", pulp.LpMinimize)

# Decision Variables

x1 = pulp.LpVariable("steak", 0, None, pulp.LpInteger)
x2 = pulp.LpVariable("PeanutButter", 0, None, pulp.LpInteger)

# Objective

prob += 2 * x1 + 3 * x2, "Total Cost"

# Constrains

prob += x1 + 2 * x2 >= 4, "Minimize Protein Intake"

prob.solve()

print("Status:", pulp.LpStatus[prob.status])

for v in prob.variables():
    print(v.name, "=", v.varValue)
    
print("optimal Solution to the problem: ", pulp.value(prob.objective))